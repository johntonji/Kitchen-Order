package com.vk.bluetoothprinter

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.pdf.PdfRenderer
import android.os.ParcelFileDescriptor
import android.util.Log
import android.widget.Toast
import java.io.File
import java.io.IOException
import java.util.UUID


/******************epson*************************/
object PrinterHelper {

    fun printPdf(context: Context, mac: String, path: String, UUID_SPP: String): Boolean {
        var isSuccess = false

        // Get Bluetooth adapter
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        val pairedDevices = bluetoothAdapter.bondedDevices
        val printerDevice = pairedDevices.find { it.address == mac }

        if (printerDevice != null) {
            // Convert the PDF to bitmaps
            val bitmaps = convertPdfToBitmaps(context, path)
            val encodedPages = bitmaps.map { encodeBitmapToEscPos(it) }

            // Send to the printer
            isSuccess = sendToPrinter(encodedPages, printerDevice, UUID_SPP)
        } else {
            Toast.makeText(context, "Printer not found", Toast.LENGTH_SHORT).show()
        }

        return isSuccess
    }

    private fun encodeBitmapToEscPos(bitmap: Bitmap): ByteArray {
        val width = bitmap.width
        val height = bitmap.height
        val bytesPerLine = (width + 7) / 8
        val data = ByteArray(bytesPerLine * height)

        for (y in 0 until height) {
            for (x in 0 until width) {
                val pixel = bitmap.getPixel(x, y)
                val luminance = (Color.red(pixel) * 0.299 +
                        Color.green(pixel) * 0.587 +
                        Color.blue(pixel) * 0.114)
                if (luminance < 128) {  // Dark pixel
                    val bytePos = y * bytesPerLine + x / 8
                    val bitPos = 7 - (x % 8)
                    data[bytePos] = data[bytePos].toInt().or(1 shl bitPos).toByte()
                }
            }
        }

        return byteArrayOf(
            0x1D, 0x76, 0x30, 0x00,  // GS v 0 command
            (bytesPerLine % 256).toByte(),
            (bytesPerLine / 256).toByte(),
            (height % 256).toByte(),
            (height / 256).toByte()
        ) + data
    }

    private fun convertPdfToBitmaps(context: Context, pdfFilePath: String): List<Bitmap> {
        val bitmaps = mutableListOf<Bitmap>()
        val pdfFile = File(pdfFilePath)

        ParcelFileDescriptor.open(pdfFile, ParcelFileDescriptor.MODE_READ_ONLY)?.use { pfd ->
            PdfRenderer(pfd).use { renderer ->
                for (i in 0 until renderer.pageCount) {
                    renderer.openPage(i).use { page ->
                        val width = 600  // Printer width
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



    private fun sendToPrinter(data: List<ByteArray>, device: BluetoothDevice, UUID_SPP: String): Boolean {
        try {
            val socket = device.createRfcommSocketToServiceRecord(UUID.fromString(UUID_SPP))
            socket.connect()
            val outStream = socket.outputStream
            data.forEach { outStream.write(it) }
            outStream.flush()
            socket.close()
            return true
        } catch (e: IOException) {
            Log.e("PRINT", "Error printing", e)
            return false
        }
    }
}
