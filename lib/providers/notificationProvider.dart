

// class Params {
//   final int page;
//   final int size;
//   final String type;
//
//   Params(this.page, this.size, this.type);
// }

// int page = 0;
// // int size = 25;
// String type = 'REALTIME';
//
// Params params = Params(page, size, type);
//
// final notificationsByTypeProvider = FutureProvider.family<dynamic, Params>((ref, params) async {
//   return ref.watch(notificationProvider).getNoficationByType(params);
// });
//
// final notiRealtimeProvider = FutureProvider.family<dynamic,int>((ref,size) async {
//   return ref.watch(notificationProvider).getNoficationRealtime(size);
// });