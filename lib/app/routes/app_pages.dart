import 'package:get/get.dart';

import '../modules/barang_admin/bindings/barang_admin_binding.dart';
import '../modules/barang_admin/views/barang_admin_view.dart';
import '../modules/barang_user/bindings/barang_user_binding.dart';
import '../modules/barang_user/views/barang_user_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/dashboard_admin/bindings/dashboard_admin_binding.dart';
import '../modules/dashboard_admin/views/dashboard_admin_view.dart';
import '../modules/detail_grooming/bindings/detail_grooming_binding.dart';
import '../modules/detail_grooming/views/detail_grooming_view.dart';
import '../modules/edit_emailpass/bindings/edit_emailpass_binding.dart';
import '../modules/edit_emailpass/views/edit_emailpass_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/grooming/bindings/grooming_binding.dart';
import '../modules/grooming/views/grooming_view.dart';
import '../modules/grooming_admin/bindings/grooming_admin_binding.dart';
import '../modules/grooming_admin/views/grooming_admin_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/layanan_grooming_admin/bindings/layanan_grooming_admin_binding.dart';
import '../modules/layanan_grooming_admin/views/layanan_grooming_admin_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/lupa_sandi/bindings/lupa_sandi_binding.dart';
import '../modules/lupa_sandi/views/lupa_sandi_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/setting_admin/bindings/setting_admin_binding.dart';
import '../modules/setting_admin/views/setting_admin_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_ADMIN,
      page: () => SettingAdminView(),
      binding: SettingAdminBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_ADMIN,
      page: () => DashboardAdminView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.GROOMING_ADMIN,
      page: () => GroomingAdminView(),
      binding: GroomingAdminBinding(),
    ),
    GetPage(
      name: _Paths.GROOMING,
      page: () => GroomingView(),
      binding: GroomingBinding(),
    ),
    GetPage(
      name: _Paths.BARANG_ADMIN,
      page: () => BarangAdminView(),
      binding: BarangAdminBinding(),
    ),
    GetPage(
      name: _Paths.BARANG_USER,
      page: () => BarangUserView(),
      binding: BarangUserBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_GROOMING,
      page: () => DetailGroomingView(),
      binding: DetailGroomingBinding(),
    ),
    GetPage(
      name: _Paths.LAYANAN_GROOMING_ADMIN,
      page: () => LayananGroomingAdminView(),
      binding: LayananGroomingAdminBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.LUPA_SANDI,
      page: () => LupaSandiView(),
      binding: LupaSandiBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_EMAILPASS,
      page: () => EditEmailpassView(),
      binding: EditEmailpassBinding(),
    ),
  ];
}
