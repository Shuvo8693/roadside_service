import 'package:flutter/widgets.dart';
import 'package:roadside_assistance/app/modules/home/model/mechanic_service_model.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';

class ServiceCategories extends StatelessWidget {
   const ServiceCategories({super.key, required this.mechanicServiceData});

 final List<MechanicServiceData> mechanicServiceData;


  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 15,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children:[
        ...mechanicServiceData.asMap().map((index, category) {
          return MapEntry(index,
            GestureDetector(
              onTap: (){
                print(category);
              },
              child: ServiceCategoryContainer(
                category: category.name??'',
                icon: category.image??'',
              ),
            ),
          );
        }).values,
      ] ,
    );
  }
}