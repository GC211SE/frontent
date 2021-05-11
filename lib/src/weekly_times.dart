/* class control timetable strings */
class WeeklyTimes {
  static final supportedLocales = const ['ko', 'en'];

  static final dates = {
    "ko": <String>['', '일', '월', '화', '수', '목', '금', '토'],
    "en": <String>['', 'SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
  };

  // 오전 9시부터로 수정함
  static final times = {
    "ko": <String>[
      '',
      /*
      '오전 1시',
      '오전 2시',
      '오전 3시',
      '오전 4시',
      '오전 5시',
      '오전 6시',
      '오전 7시',
      '오전 8시',
       */
      '오전 9시',
      '오전 10시',
      '오전 11시',
      '오후 12시',
      '오후 1시',
      '오후 2시',
      '오후 3시',
      '오후 4시',
      '오후 5시',
      '오후 6시',
      '오후 7시',
      '오후 8시',
      '오후 9시',
      '오후 10시',
      '오후 11시',
    ],
    "de": <String>[
      '',
      /*
      '01:00',
      '02:00',
      '03:00',
      '04:00',
      '05:00',
      '06:00',
      '07:00',
      '08:00',
      '09:00',
      */
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
      '23:00',
    ],
  };

  static bool localContains(String locale) => supportedLocales.contains(locale);
}