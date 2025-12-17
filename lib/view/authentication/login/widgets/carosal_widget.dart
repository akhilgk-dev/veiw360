import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:view360/api/banner/banner_api.dart';

class CarosalWidget extends StatelessWidget {
  final String page;
  const CarosalWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: CarouselSlider(
        options: CarouselOptions(
          height: page == 'HOMEPAGE' ? 100 : 110,
          autoPlay: true,
          padEnds: true,
          viewportFraction: 1.0,
        ),
        items:
            [
              // Image.asset(
              //   'assets/images/banner-1.png',
              //   width: MediaQuery.of(context).size.width,
              //   fit: page == 'HOMEPAGE' ? BoxFit.fill : BoxFit.fill,
              // ),
              // Image.asset(
              //   'assets/images/mzadcom-banner-2.png',
              //   width: MediaQuery.of(context).size.width,
              //   fit: page == 'HOMEPAGE' ? BoxFit.fill : BoxFit.fill,
              // ),
              'assets/images/mzadcom-banner-2.png',
              'assets/images/banner-1.png',
            ].map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: AssetImage(item),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    //child: item,
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}

class PartnersCarousel extends StatelessWidget {
  const PartnersCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 110,
          autoPlay: true,
          padEnds: true,
          viewportFraction: 0.3,
        ),
        items:
            [
              // Image.asset(
              //   'assets/images/banner-1.png',
              //   width: MediaQuery.of(context).size.width,
              //   fit: page == 'HOMEPAGE' ? BoxFit.fill : BoxFit.fill,
              // ),
              // Image.asset(
              //   'assets/images/mzadcom-banner-2.png',
              //   width: MediaQuery.of(context).size.width,
              //   fit: page == 'HOMEPAGE' ? BoxFit.fill : BoxFit.fill,
              // ),
              'https://www.mzadcom.om/services/public/uploads/organization/al_ghalbi.jpg',
              'https://www.mzadcom.om/services/public/uploads/organization/al_haditha_energy_s.a.o.c_20250729131106.jpg',
              'https://www.mzadcom.om/services/public/uploads/organization/oman_dd_20240417160646.jpg',
              'https://www.mzadcom.om/services/public/uploads/organization/omfico_20240522114028.jpg',
              'https://www.mzadcom.om/services/public/uploads/organization/vodafone.jpg',
              'https://www.mzadcom.om/services/public/uploads/organization/mazoon_electricity_company_saoc.png',
              'https://www.mzadcom.om/services/public/uploads/organization/duqum_development_company_s.a.o.c.jpg',
              'https://www.mzadcom.om/services/public/uploads/organization/daleel_petroleum_20230724121323.png',
              'https://www.mzadcom.om/services/public/uploads/organization/seeh_al_sarya_engineering_llc.jpg',
              'https://www.mzadcom.om/services/public/uploads/organization/oman_fiber_optics.jpg',
            ].map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(item),
                        fit: BoxFit.contain,
                      ),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.2,
                      ),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    //child: item,
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}

class BannersCarosal extends StatelessWidget {
  final String page;
  final BannerResponse bannerResponse;
  const BannersCarosal({
    super.key,
    required this.page,
    required this.bannerResponse,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: CarouselSlider(
        options: CarouselOptions(
          height: page == 'HOMEPAGE' ? 100 : 110,
          autoPlay: true,
          padEnds: true,
          viewportFraction: 1.0,
        ),
        items: bannerResponse.banners.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                //child: item,
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
