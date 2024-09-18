import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/model/home_models/promotion_list_model.dart';
import 'package:sizer/sizer.dart';

import 'image_spinning.dart';

class PromotionWidget extends StatelessWidget {
  PromotionWidget({super.key, required this.data});

  final PromoListData data;
  final staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            builder: (context) => Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 100.w,
                              height: 50.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: data.image!,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Center(
                                      child: ImageSpinning(
                                    withOpasity: true,
                                  )),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/images/image-not-available.png'),
                                ),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: staticVar.primaryColor,
                                    )))
                          ],
                        ),
                        SizedBox(height: 1.h),
                        SizedBox(
                            width: 100.w,
                            child: Text(
                              data.title ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            )),
                        SizedBox(height: 1.h),
                        SizedBox(
                          width: 100.w,
                          child: Text(data.description ?? ''),
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                ));
      },
      child: SizedBox(
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            // color: cardcolor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [staticVar.shadow]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: data.thumbnail ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
                child: ImageSpinning(
              withOpasity: true,
            )),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/image-not-available.png'),
          ),
        ),
      )),
    );
  }
}
