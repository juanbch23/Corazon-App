import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Importaciones del patrón MVVM - Servicios
import 'servicios/api_service.dart';

// Importaciones del patrón MVVM - ViewModels
import 'vistamodelos/login_viewmodel.dart';
import 'vistamodelos/registro_viewmodel.dart';
import 'vistamodelos/home_viewmodel.dart';
import 'vistamodelos/diagnostico_viewmodel.dart';
import 'vistamodelos/resultados_viewmodel.dart';
import 'vistamodelos/configuracion_viewmodel.dart';
import 'vistamodelos/admin_viewmodel.dart';

// Importaciones del patrón MVVM - Vistas
import 'vistas/login_vista.dart';
import 'vistas/registro_vista.dart';
import 'vistas/home_vista.dart';
import 'vistas/diagnostico_vista.dart';
import 'vistas/resultados_vista.dart';
import 'vistas/configuracion_vista.dart';
import 'vistas/admin_vista.dart';

void main() {
  // Inicializar el servicio de API
  ApiService().init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Configuración de rutas usando patrón MVVM
  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Ruta de login - entrada principal
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginVista(),
      ),
      // Ruta de registro - crear nueva cuenta
      GoRoute(
        path: '/registro',
        builder: (context, state) => const RegistroVista(),
      ),
      // Ruta principal después del login - menú principal
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeVista(),
      ),
      // Ruta de diagnóstico cardiovascular
      GoRoute(
        path: '/diagnostico',
        builder: (context, state) => const DiagnosticoVista(),
      ),
      // Ruta de resultados y historial
      GoRoute(
        path: '/resultados',
        builder: (context, state) => const ResultadosVista(),
      ),
      // Ruta de configuración del perfil
      GoRoute(
        path: '/configuracion',
        builder: (context, state) => const ConfiguracionVista(),
      ),
      // Ruta del panel de administración
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminVista(),
      ),
      // Redirección de raíz al login
      GoRoute(
        path: '/',
        redirect: (context, state) {
          return '/login';
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModels para el patrón MVVM - Sistema de diagnóstico cardiovascular
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegistroViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => DiagnosticoViewModel()),
        ChangeNotifierProvider(create: (_) => ResultadosViewModel()),
        ChangeNotifierProvider(create: (_) => ConfiguracionViewModel()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
      ],
      child: MaterialApp.router(
        title: 'Diagnóstico Cardiovascular - Patrón MVVM',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('en', 'US'),
        ],
        locale: const Locale('es', 'ES'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          cardTheme: const CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
