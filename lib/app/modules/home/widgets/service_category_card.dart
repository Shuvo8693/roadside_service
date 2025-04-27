import 'package:flutter/widgets.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';

class ServiceCategories extends StatefulWidget {
  @override
  State<ServiceCategories> createState() => _ServiceCategoriesState();
}

class _ServiceCategoriesState extends State<ServiceCategories> {

  List<Map<String, dynamic>> serviceCategories = [
    {'category': 'Towing', 'icon': AppIcons.towingIcon},
    {'category': 'Lockout', 'icon': AppIcons.lockoutIcon},
    {'category': 'Jump Start', 'icon': AppIcons.jumpStartServiceIcon},
    {'category': 'Flat Tire Repair', 'icon': AppIcons.flatTireIcon},
    {'category': 'Gasoline Delivery', 'icon': AppIcons.gasolineIcon},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children:[
        ...serviceCategories.asMap().map((index, category) {
          return MapEntry(index,
            GestureDetector(
              onTap: (){
                print(category['category']);
              },
              child: ServiceCategoryContainer(
                category: category['category'],
                icon: category['icon'],
              ),
            ),
          );
        }).values,
      ] ,
    );
  }
}