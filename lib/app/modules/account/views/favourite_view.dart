import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/account/controllers/favourites_controller.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_providere_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/distance_mode/distance_mode.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';

import '../model/favourite_model.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  final FavouritesController _favouritesController = Get.put(FavouritesController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _favouritesController.fetchFavourite();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite'),
        centerTitle: true,
      ),
      body: Obx((){
        List<Favourite> favouriteLIst =_favouritesController.favouriteResponseModel.value.data??[];
        if(_favouritesController.isLoading.value){
          return Center(child: CustomPageLoading());
        }
        if(favouriteLIst.isEmpty){
          return Center(child: Text('Favourite looks empty'));
        }
        return  Padding(
          padding:  EdgeInsets.all(8.0.sp),
          child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
            final favouriteItem = favouriteLIst[index];
            double distance = Distance.calculateDuration(favouriteItem.mechanic?.serviceRadius??0.0, 'car');
              return ServiceProviderCard(
                name: favouriteItem.mechanic?.name??'',
                title: favouriteItem.mechanic?.role??'',
                distance: "${favouriteItem.mechanic?.serviceRadius} K/m",
                rating: 4.5,
                duration: '${distance.toPrecision(3)} min',
                imageUrl: favouriteItem.mechanic?.image??'',
                isFavourite: favouriteItem.isFavorite??false,
                onTap: () {
                  Get.toNamed(Routes.MECHANICDETAILS);
                }, favouriteTap: () {  },
              );
            },
          ),
        );
      }

      ),
    );
  }
}
