import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/ui/state_notifiers/full_weather_state_notifier.dart'
    as w;

import '../../../domain/entities/unit_system.dart';
import '../../state_notifiers/unit_system_state_notifier.dart';
import 'additional_info_tile.dart';

class AdditionalInfoWidget extends ConsumerWidget {
  const AdditionalInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      w.fullWeatherStateNotifierProvider.select(
        (state) => state.fullWeather!.currentWeather,
      ),
    );
    final currentDayForecast = ref.watch(
      w.fullWeatherStateNotifierProvider.select(
        (state) => state.fullWeather!.currentDayForecast,
      ),
    );
    final timeZoneOffset = ref.watch(
      w.fullWeatherStateNotifierProvider.select(
        (state) => state.fullWeather!.timeZoneOffset,
      ),
    );

    final unitSystem = ref.watch(
      unitSystemStateNotifierProvider.select(
        (state) => state.unitSystem!,
      ),
    );

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(bottom: 2.h, top: 2.h, left: 5.w, right: 5.w),
          child: Row(
            children: [
              AdditionalInfoTile(
                title: 'Feels like',
                value: '${currentWeather.tempFeel.round()}°',
              ),
              AdditionalInfoTile(
                title: 'Humidity',
                value: '${currentWeather.humidity}%',
              ),
              AdditionalInfoTile(
                title: 'Wind speed',
                value: '${currentWeather.windSpeed.round()} ${() {
                  switch (unitSystem) {
                    case UnitSystem.metric:
                      return 'km/h';

                    case UnitSystem.imperial:
                      return 'mph';
                  }
                }()}',
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 2.h,
            top: 1.h,
            right: 5.w,
            left: 5.w,
          ),
          child: Row(
            children: [
              AdditionalInfoTile(
                title: 'Clouds',
                value: '${currentWeather.clouds.toString()}%',
              ),
              AdditionalInfoTile(
                title: 'UV index',
                value: currentWeather.uvIndex.toString(),
              ),
              AdditionalInfoTile(
                title: 'Chance of rain',
                value: '${(currentDayForecast.pop * 100).round()}%',
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 3.h,
            top: 1.h,
            right: 5.w,
            left: 5.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdditionalInfoTile(
                title: 'Sunrise',
                value: DateFormat.Hm().format(
                  currentDayForecast.sunrise.toUtc().add(timeZoneOffset),
                ),
              ),
              AdditionalInfoTile(
                title: 'Sunset',
                value: DateFormat.Hm().format(
                  currentDayForecast.sunset.toUtc().add(timeZoneOffset),
                ),
              ),
              AdditionalInfoTile(
                title: 'Pressure',
                value: '${currentWeather.pressure} mbar',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
