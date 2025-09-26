import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../vistamodelos/login_viewmodel.dart';

/// Vista de Login con diseño original - Diagnóstico Cardiovascular
class LoginVista extends StatefulWidget {
  const LoginVista({Key? key}) : super(key: key);

  @override
  State<LoginVista> createState() => _LoginVistaState();
}

class _LoginVistaState extends State<LoginVista> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializar el ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC), // Fondo amarillo crema como en la imagen original
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card principal con diseño de la imagen original
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Título "Bienvenido" exacto como en la imagen
                          Text(
                            'Bienvenido',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Campo DNI (Usuario) como en la imagen
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'DNI',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su DNI';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Campo Contraseña como en la imagen
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su contraseña';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          
                          // Mostrar error si existe
                          Consumer<LoginViewModel>(
                            builder: (context, viewModel, child) {
                              if (viewModel.mensajeError != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    viewModel.mensajeError!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          
                          // Botón "Ingresar" con diseño original
                          Consumer<LoginViewModel>(
                            builder: (context, viewModel, child) {
                              return SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: viewModel.estaCargando ? null : _iniciarSesion,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade600, // Color naranja como en las imágenes
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: viewModel.estaCargando
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                          'Ingresar',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Enlace "¿No tienes una cuenta? Regístrate aquí" como en la imagen original
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black54),
                              children: [
                                const TextSpan(text: '¿No tienes una cuenta? '),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => context.go('/registro'),
                                    child: Text(
                                      'Regístrate aquí',
                                      style: TextStyle(
                                        color: Colors.red.shade600, // Rojo como en la imagen original
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<LoginViewModel>();
      
      final exito = await viewModel.iniciarSesion(
        _usernameController.text,
        _passwordController.text,
      );

      if (exito && mounted) {
        // Navegar a la pantalla principal según el tipo de usuario
        final usuario = viewModel.usuarioAutenticado!;
        if (usuario.esAdministrador) {
          context.go('/admin');
        } else {
          context.go('/home');
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}