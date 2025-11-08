import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'services/api_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/diagnostico_screen.dart';
import 'screens/resultados_screen.dart';
import 'screens/register_screen.dart';
import 'screens/pantalla_configuracion.dart';
import 'screens/admin_dashboard.dart';
import 'screens/panel_administracion.dart';
import 'screens/admin_diagnosticos.dart';

void main() {
  // Inicializar el servicio de API
  ApiService().init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Configuración de rutas
  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/diagnostico',
        builder: (context, state) => const DiagnosticoScreen(),
      ),
      GoRoute(
        path: '/resultados',
        builder: (context, state) => const ResultadosScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/configuracion',
        builder: (context, state) => const PantallaConfiguracion(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/admin/pacientes',
        builder: (context, state) => const PanelAdministracion(),
      ),
      GoRoute(
        path: '/admin/diagnosticos/:pacienteId',
        builder: (context, state) {
          final pacienteId = state.pathParameters['pacienteId']!;
          return AdminDiagnosticos(pacienteId: pacienteId);
        },
      ),
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        title: 'Diagnóstico Cardiovascular',
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
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange.shade600,
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
