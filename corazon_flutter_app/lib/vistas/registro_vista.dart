import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../vistamodelos/registro_viewmodel.dart';

/// Vista de Registro siguiendo patrón MVVM
/// Permite crear nuevas cuentas de usuario en el sistema
/// Se comunica con RegistroViewModel para la lógica de negocio
class RegistroVista extends StatefulWidget {
  const RegistroVista({super.key});

  @override
  State<RegistroVista> createState() => _RegistroVistaState();
}

class _RegistroVistaState extends State<RegistroVista> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade600,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        title: const Text('Registro de Paciente'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Ícono y título
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.person_add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Formulario principal
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Consumer<RegistroViewModel>(
                    builder: (context, viewModel, child) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título del formulario
                            const Center(
                              child: Text(
                                'Crear Cuenta Nueva',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Campos de usuario y contraseña
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Usuario',
                                    hint: 'Nombre de usuario',
                                    icon: Icons.person,
                                    onChanged: viewModel.setUsuario,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Requerido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Contraseña',
                                    hint: 'Contraseña',
                                    icon: Icons.lock,
                                    obscureText: true,
                                    onChanged: viewModel.setContrasena,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Requerido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Campos de nombre y apellido
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Nombre',
                                    hint: 'Tu nombre',
                                    icon: Icons.badge,
                                    onChanged: viewModel.setNombre,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Requerido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Apellido',
                                    hint: 'Tu apellido',
                                    icon: Icons.badge,
                                    onChanged: viewModel.setApellido,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Requerido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Campos de fecha y género
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateField(
                                    label: 'Fecha de Nacimiento',
                                    hint: 'Seleccionar fecha',
                                    onChanged: viewModel.setFechaNacimiento,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDropdownField(
                                    label: 'Género',
                                    hint: 'Seleccionar',
                                    icon: Icons.person,
                                    items: ['Masculino', 'Femenino'],
                                    onChanged: (value) => viewModel.setGenero(value?.toLowerCase() ?? ''),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Campos de teléfono y DNI
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Teléfono',
                                    hint: 'Número de teléfono',
                                    icon: Icons.phone,
                                    keyboardType: TextInputType.phone,
                                    onChanged: viewModel.setTelefono,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Requerido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'DNI',
                                    hint: 'Documento de identidad',
                                    icon: Icons.credit_card,
                                    keyboardType: TextInputType.number,
                                    onChanged: viewModel.setDni,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Requerido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Campo de dirección
                            _buildTextField(
                              label: 'Dirección',
                              hint: 'Tu dirección completa',
                              icon: Icons.location_on,
                              onChanged: viewModel.setDireccion,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'La dirección es requerida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Mensajes de error o éxito
                            if (viewModel.mensajeError != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  border: Border.all(color: Colors.red.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error, color: Colors.red.shade600),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        viewModel.mensajeError!,
                                        style: TextStyle(color: Colors.red.shade700),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (viewModel.mensajeExito != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  border: Border.all(color: Colors.green.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green.shade600),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        viewModel.mensajeExito!,
                                        style: TextStyle(color: Colors.green.shade700),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Botón de registro
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: viewModel.estaCargando 
                                  ? null 
                                  : () => _registrarUsuario(context, viewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: viewModel.estaCargando
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Registrarse',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Link para ir al login
                            Center(
                              child: TextButton(
                                onPressed: () => context.go('/login'),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.grey),
                                    children: [
                                      const TextSpan(text: '¿Ya tienes cuenta? '),
                                      TextSpan(
                                        text: 'Iniciar sesión',
                                        style: TextStyle(
                                          color: Colors.orange.shade600,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.orange.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade600),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Requerido',
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              onChanged(date.toIso8601String().split('T')[0]);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(Icons.calendar_today, color: Colors.orange.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade600),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Requerido',
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.orange.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade600),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
        ),
        const SizedBox(height: 4),
        const Text(
          'Requerido',
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Future<void> _registrarUsuario(BuildContext context, RegistroViewModel viewModel) async {
    if (_formKey.currentState?.validate() ?? false) {
      final exito = await viewModel.registrarUsuario();
      
      if (exito && mounted) {
        // Mostrar mensaje de éxito y navegar al login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario registrado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Esperar un poco y navegar al login
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          context.go('/login');
        }
      }
    }
  }
}