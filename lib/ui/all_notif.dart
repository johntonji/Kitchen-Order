
import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/models/notif_model.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_client.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:provider/provider.dart';

class AllNotif extends StatefulWidget {
  const AllNotif({Key? key}) : super(key: key);

  @override
  State<AllNotif> createState() => _AllNotifState();
}

class _AllNotifState extends State<AllNotif> {
UserModel userModel=UserModel();
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {
      return PopScope(
        onPopInvoked: (didPop){
      //  SharedPreferenceManager.getInstance().getUserData().then((data) {
      //    for(NotifModel notif in provider.notiList){
      //       provider.readNotif(notif.notiUuid,data.authToken!);
      //     }
      //   });
       },
        child: Scaffold(
          appBar: AppBar(
            title:   Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Notification", style: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoBold, color: AppAssets.primaryColor)),
                                    SizedBox(width: 10,),
                                     Container(
                                                     padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      shape:BoxShape.circle,
                                                      color: Colors.green
                                                    ),
                                                    child: Center(
                                                    child: Text(AppProvider.notifCount.toString(),style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                                                    ), ),
                                  ],
                                ),
                                 TextButton(
                                     style: ButtonStyle(
                                     foregroundColor: WidgetStatePropertyAll(Colors.black)),
                                     onPressed: () async {
                                       SharedPreferenceManager.getInstance().getUserData().then((data) {
                                        provider.deleteNotif(data.authToken!);
                                       });
                                       setState(() { });
                                      },
                                      child: Text("Clear All",style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontSize: 14),)),
                              ],
                            ),
            // Text('Add Printer(s)',style: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoBold, color: AppAssets.primaryColor),),
                    ),
                    body:provider.notiList.isNotEmpty
                   ? ListView.builder(
                        itemCount: provider.notiList.length ,
                        itemBuilder: (BuildContext context, int index) {  
                           NotifModel notif=provider.notiList[index];
                         return ListTile(
                          // onTap: (){
                          //       SharedPreferenceManager.getInstance().getUserData().then((data) {
                          //       provider.readNotif(notif.notiUuid,data.authToken!);
                          //   });
                          // },
                          leading:  (notif.image!=null)
                        ?  ClipOval(
                        child: Image.network(
                        notif.image! ,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                        'assets/icons/basket.png',
                         width: 40,
                         height: 40,
                         fit: BoxFit.cover,
                       );
                      },
                     ),
                     ):
                           Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image:
                               AssetImage('assets/icons/basket.png') ,
                              fit: BoxFit.fill)
                            ),
                          ),
                          title: Text(notif.message!,style: TextStyle(fontFamily: AppAssets.nunitoRegular ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          subtitle: Text(formatDateTime(notif.date!),style: TextStyle(fontFamily: AppAssets.nunitoRegular ,fontSize: 13,),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          );
                      },)
                    : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Image.asset("assets/icons/no_noti.png",
                      width: MediaQuery.sizeOf(context).width/3,
                      height:  MediaQuery.sizeOf(context).width/3,
                      ),
                      SizedBox(height: 10,),
                      Text("No Notifications Yet",style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontSize: 15,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                    )
            ),
      );
    });
  }
}
