package com.eatsbee.order_receiving


import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import com.vk.bluetoothprinter.MainActivity2
import com.vk.bluetoothprinter.PrinterHelper
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.net.wifi.WifiManager
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import java.util.concurrent.Executors
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.pdf.PdfRenderer
import android.os.ParcelFileDescriptor
import android.util.Log
import com.starmicronics.stario10.InterfaceType
import com.starmicronics.stario10.StarConnectionSettings
import com.starmicronics.stario10.StarPrinter
import com.starmicronics.stario10.starxpandcommand.DocumentBuilder
import com.starmicronics.stario10.starxpandcommand.PrinterBuilder
import com.starmicronics.stario10.starxpandcommand.StarXpandCommandBuilder
import com.starmicronics.stario10.starxpandcommand.printer.ImageParameter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.io.File
import androidx.lifecycle.lifecycleScope
import com.starmicronics.stario10.starxpandcommand.DrawerBuilder
import com.starmicronics.stario10.starxpandcommand.drawer.Channel
import com.starmicronics.stario10.starxpandcommand.drawer.OpenParameter
 
 
// import com.bugsnag.android.Bugsnag
import kotlinx.coroutines.*
import com.starmicronics.stario10.starxpandcommand.printer.CutType
import com.starmicronics.stario10.starxpandcommand.BuzzerBuilder
// import com.starmicronics.stario10.starxpandcommand.buzzer.Channel
import com.starmicronics.stario10.starxpandcommand.buzzer.DriveParameter
 


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.vk.bluetoothprinter" 
    private lateinit var nsdManager: NsdManager
    private val discoveredPrinters = mutableListOf<Map<String, String>>()
    private var result: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // val config = com.bugsnag.android.Configuration("d884b2f8bd6f92d6f08c6d7d88973161")
        //  Bugsnag.start(applicationContext, config) 
      nsdManager = getSystemService(Context.NSD_SERVICE) as NsdManager
        // Set up the MethodChannel to listen for calls from Flutter
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            // Check which method is being invoked
            if (call.method == "printPdf") {
                // Get arguments from Flutter
                val macAddress = call.argument<String>("mac")
                val path = call.argument<String>("path")
                val uuidSpp = call.argument<String>("UUID_SPP")

                if (macAddress != null && path != null && uuidSpp != null) {
                    // Call the printPdf method from MainActivity2

                    val success = PrinterHelper.printPdf(applicationContext, macAddress, path, uuidSpp)

                    if (success) {
                        result.success("Printed successfully")
                    } else {
                        result.error("ERROR", "Failed to print", null)
                    }
                } else {
                    result.error("INVALID_ARGS", "Missing arguments", null)
                }
            } 
            else if(call.method=="discoverPrinters"){
                  this.result = result
                discoverPrintersForFlutter()
            }
            else if (call.method == "printPdfWithStar") {
                val identifier = call.argument<String>("identifier")
                val pdfPath = call.argument<String>("pdfPath")
        

                if (identifier != null && pdfPath != null) {
                    lifecycleScope.launch {
                            val success = StarPrinterHelper.printPdfWithStar(
                                this@MainActivity,
                                identifier,
                                pdfPath
                            )
                            result.success(success)
                        }
                    // val isSuccess = StarPrinterHelper.printPdfWithStar(applicationContext, identifier, pdfPath)
                    // result.success(isSuccess)
                } else {
                    result.error("INVALID_ARGS", "Missing arguments", null)
                }
            }
            else {
                result.notImplemented()
            }
        }


    }
    private fun discoverPrintersForFlutter(): MutableList<Map<String, String>> {
        
        val printersList = mutableListOf<Map<String, String>>()

        val printerServiceTypes = arrayOf(
            "_ipp._tcp.",
            "_printer._tcp.",
            "_pdl-datastream._tcp.",
            "_http._tcp.",
            "_ipps._tcp.",
            "_socket._tcp.",
            "_starprinter._tcp."
        )
        discoveredPrinters.clear()
        printerServiceTypes.forEach { serviceType ->
            nsdManager.discoverServices(
                serviceType,
                NsdManager.PROTOCOL_DNS_SD,
                object : NsdManager.DiscoveryListener {
                    override fun onDiscoveryStarted(regType: String) {
                        Log.d("PrinterDiscovery", "Started: $regType")
                    }
 
                    override fun onServiceFound(service: NsdServiceInfo) {
                        nsdManager.resolveService(service, object : NsdManager.ResolveListener {
                            override fun onServiceResolved(service: NsdServiceInfo) {
                                val printerInfo = mapOf(
                                    "name" to service.serviceName,
                                    "ip" to (service.host?.hostAddress ?: "unknown"),
                                    "port" to service.port.toString(),
                                    "type" to service.serviceType
                                )
                                discoveredPrinters.add(printerInfo)
                                 printersList.add(printerInfo)
                            }
 
                            override fun onResolveFailed(service: NsdServiceInfo, errorCode: Int) {
                                Log.d("PrinterDiscovery", "Resolve failed: $errorCode")
                            }
                        })
                    }
 
                
                    override fun onServiceLost(service: NsdServiceInfo) {}
                    override fun onDiscoveryStopped(serviceType: String) {}
                    override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {
                        // result?.error("DISCOVERY_FAILED", "Failed to start discovery", null)
                    }
                    override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {}
                }
            )
        }
        Handler(Looper.getMainLooper()).postDelayed({
        result?.success(discoveredPrinters)
    }, 5000)
        return printersList
    }

object StarPrinterHelper {
 
    suspend fun printPdfWithStar(context: Context, identifier: String, pdfPath: String): Boolean {
      
        var isSuccess = false
 
        val interfaceType = InterfaceType.Lan
        val settings = StarConnectionSettings(interfaceType, identifier)
        val printer = StarPrinter(settings, context)
 
        try {
            val bitmaps = convertPdfToBitmaps(pdfPath)
 
            val builder = StarXpandCommandBuilder()
            val docBuilder = DocumentBuilder()

        // // Add buzzer command to stop ringing
        // docBuilder.addBuzzer(
        //   BuzzerBuilder()
        //     .actionDrive(DriveParameter()
        //     .setChannel(Channel.No1)
        //     .setOnTime(0)
        //     .setOffTime(0)
        //     .setRepeat(0))
        //   )

  docBuilder.addDrawer(
                DrawerBuilder()
                    .actionOpen(
                        OpenParameter()
                            .setChannel(Channel.No1) // Try Channel.No1
                            .setOnTime(200) // 200ms pulse for a short buzz
                    )
            )
            docBuilder.addDrawer(
                DrawerBuilder()
                    .actionOpen(
                        OpenParameter()
                            .setChannel(Channel.No2) // Try Channel.No2
                            .setOnTime(200) // 200ms pulse for a short buzz
                    )
            )
            bitmaps.forEach { bitmap ->
                docBuilder.addPrinter(
                    PrinterBuilder()
                        .actionPrintImage(ImageParameter(bitmap, 600))
                        .actionFeedLine(1)
                )
            }

            docBuilder.addPrinter(
                PrinterBuilder()
                    .actionCut(CutType.Full)  // or CutType.Full
            )
 
            builder.addDocument(docBuilder)
            val commands = builder.getCommands()
 
            printer.openAsync().await()
            printer.printAsync(commands).await()
 
            Log.d("Printing", "PDF printed successfully.")
            isSuccess = true
 
            // Free bitmap memory
            bitmaps.forEach { it.recycle() }
 
        } catch (e: Exception) {
            Log.e("Printing", "Error printing PDF: ${e.message}", e)
 
            // // ✅ Send error details to Bugsnag
            // Bugsnag.notify(e) { event ->
            //     event.addMetadata("Printer", "Identifier", identifier)
            //     event.addMetadata("Printer", "PdfPath", pdfPath)
            //     event.addMetadata("Printer", "InterfaceType", interfaceType.toString())
            //     event.addMetadata("Printer", "SuccessBeforeError", isSuccess.toString())
            //     true // Keep event
            // }
 
        } finally {
            try {
                printer.closeAsync().await()
                delay(500) // Ensure connection closes before reusing printer
            } catch (closeEx: Exception) {
                // Bugsnag.notify(closeEx) { event ->
                //     event.addMetadata("Printer", "ErrorWhileClosing", true)
                //     true
                // }
            }
        }
 
        return isSuccess
    }
 
    private fun convertPdfToBitmaps(pdfFilePath: String): List<Bitmap> {
        val bitmaps = mutableListOf<Bitmap>()
        val pdfFile = File(pdfFilePath)
 
        ParcelFileDescriptor.open(pdfFile, ParcelFileDescriptor.MODE_READ_ONLY)?.use { pfd ->
            PdfRenderer(pfd).use { renderer ->
                for (i in 0 until renderer.pageCount) {
                    renderer.openPage(i).use { page ->
                        val width = 600 // Star printer width in dots
                        val height = (page.height * width / page.width).toInt()
                        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                        bitmap.eraseColor(Color.WHITE)
                        page.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)
                        bitmaps.add(bitmap)
                    }
                }
            }
        }
        return bitmaps
    }
}


// object StarPrinterHelper {

//     fun printPdfWithStar(
//         context: Context,
//          identifier: String, pdfPath: String): Boolean {
//         var isSuccess = false
          
//         val interfaceType = InterfaceType.Lan
//         val settings = StarConnectionSettings(interfaceType, identifier)
//         val printer = StarPrinter(settings, context)

//         val job = SupervisorJob()
//         val scope = CoroutineScope(Dispatchers.Default + job)

//         scope.launch {
//             try {
//                 val bitmaps = convertPdfToBitmaps(pdfPath)

//                 val builder = StarXpandCommandBuilder()
//                 val docBuilder = DocumentBuilder()

//                 bitmaps.forEach { bitmap ->
//                     docBuilder.addPrinter(
//                         PrinterBuilder()
//                             .actionPrintImage(ImageParameter(bitmap, 406)) // scale to printer width
//                             .actionFeedLine(1)
//                     )
//                 }

//                 builder.addDocument(docBuilder)

//                 val commands = builder.getCommands()

//                 printer.openAsync().await()
//                 printer.printAsync(commands).await()
//                 Log.d("Printing", "PDF printed successfully.")
//                 isSuccess = true

//             } catch (e: Exception) {
//                 Log.e("Printing", "Error printing PDF: ${e.message}", e)
//             } finally {
//                 try {
//                     printer.closeAsync().await()
//                 } catch (_: Exception) {}
//             }
//         }
//         return isSuccess
//     }

//     private fun convertPdfToBitmaps(pdfFilePath: String): List<Bitmap> {
//         val bitmaps = mutableListOf<Bitmap>()
//         val pdfFile = File(pdfFilePath)

//         ParcelFileDescriptor.open(pdfFile, ParcelFileDescriptor.MODE_READ_ONLY)?.use { pfd ->
//             PdfRenderer(pfd).use { renderer ->
//                 for (i in 0 until renderer.pageCount) {
//                     renderer.openPage(i).use { page ->
//                         val width = 406 // Star printer dots width
//                         val height = (page.height * width / page.width).toInt()
//                         val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
//                         bitmap.eraseColor(Color.WHITE)
//                         page.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)
//                         bitmaps.add(bitmap)
//                     }
//                 }
//             }
//         }
//         return bitmaps
//     }

// }
    override fun onDestroy() {
        nsdManager.stopServiceDiscovery(object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(regType: String) {}
            override fun onServiceFound(service: NsdServiceInfo) {}
            override fun onServiceLost(service: NsdServiceInfo) {}
            override fun onDiscoveryStopped(serviceType: String) {}
            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {}
            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {}
        })
        super.onDestroy()
    }
}