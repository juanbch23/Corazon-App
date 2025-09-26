import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vistamodelos/configuracion_viewmodel.dart';

/// Vista de configuración del perfil de usuario
/// 
/// Permite al usuario actualizar su información personal incluyendo:
/// - Datos básicos (nombre, apellidos, email)
/// - Información médica (edad, peso, altura)
/// - Configuraciones de la aplicación
/// 
/// Integrada con ConfiguracionViewModel para manejo de estado y validación
class ConfiguracionVista extends StatefulWidget {
  const ConfiguracionVista({super.key});

  @override
  State<ConfiguracionVista> createState() => _ConfiguracionVistaState();
}

class _ConfiguracionVistaState extends State<ConfiguracionVista> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar datos del usuario al inicializar la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfiguracionViewModel>().cargarDatosUsuario();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E86AB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ConfiguracionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.estaCargando) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E86AB)),
              ),
            );
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2E86AB), Color(0xFFA23B72)],
              ),
            ),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Encabezado del perfil
                        _construirEncabezadoPerfil(),
                        const SizedBox(height: 30),
                        
                        // Información personal
                        _construirSeccionInformacionPersonal(viewModel),
                        const SizedBox(height: 25),
                        
                        // Información médica
                        _construirSeccionInformacionMedica(viewModel),
                        const SizedBox(height: 25),
                        
                        // Configuraciones de la aplicación
                        _construirSeccionConfiguracionApp(viewModel),
                        const SizedBox(height: 30),
                        
                        // Botones de acción
                        _construirBotonesAccion(context, viewModel),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construye el encabezado del perfil con avatar
  Widget _construirEncabezadoPerfil() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
              color: Color(0xFF2E86AB),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Mi Perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la sección de información personal
  Widget _construirSeccionInformacionPersonal(ConfiguracionViewModel viewModel) {
    return _construirSeccion(
      titulo: 'Información Personal',
      icono: Icons.person_outline,
      children: [
        _construirCampoTexto(
          label: 'Nombre',
          controller: viewModel.nombreController,
          validator: viewModel.validarNombre,
          icono: Icons.person,
        ),
        const SizedBox(height: 16),
        _construirCampoTexto(
          label: 'Apellidos',
          controller: viewModel.apellidosController,
          validator: viewModel.validarApellidos,
          icono: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _construirCampoTexto(
          label: 'Email',
          controller: viewModel.emailController,
          validator: viewModel.validarEmail,
          icono: Icons.email,
          keyboardType: TextInputType.emailAddress,
          readOnly: true, // Email no editable por seguridad
        ),
      ],
    );
  }

  /// Construye la sección de información médica
  Widget _construirSeccionInformacionMedica(ConfiguracionViewModel viewModel) {
    return _construirSeccion(
      titulo: 'Información Médica',
      icono: Icons.local_hospital,
      children: [
        Row(
          children: [
            Expanded(
              child: _construirCampoTexto(
                label: 'Edad',
                controller: viewModel.edadController,
                validator: viewModel.validarEdad,
                icono: Icons.cake,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _construirDropdown(
                label: 'Sexo',
                value: viewModel.sexoSeleccionado,
                items: viewModel.opcionesSexo,
                onChanged: viewModel.actualizarSexo,
                icono: Icons.wc,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _construirCampoTexto(
                label: 'Peso (kg)',
                controller: viewModel.pesoController,
                validator: viewModel.validarPeso,
                icono: Icons.monitor_weight,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _construirCampoTexto(
                label: 'Altura (cm)',
                controller: viewModel.alturaController,
                validator: viewModel.validarAltura,
                icono: Icons.height,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección de configuración de la aplicación
  Widget _construirSeccionConfiguracionApp(ConfiguracionViewModel viewModel) {
    return _construirSeccion(
      titulo: 'Configuración de la Aplicación',
      icono: Icons.settings,
      children: [
        _construirSwitchTile(
          titulo: 'Notificaciones',
          subtitulo: 'Recibir recordatorios y alertas',
          valor: viewModel.notificacionesActivadas,
          onChanged: viewModel.toggleNotificaciones,
          icono: Icons.notifications,
        ),
        _construirSwitchTile(
          titulo: 'Modo Oscuro',
          subtitulo: 'Cambiar apariencia de la aplicación',
          valor: viewModel.modoOscuroActivado,
          onChanged: viewModel.toggleModoOscuro,
          icono: Icons.dark_mode,
        ),
        _construirSwitchTile(
          titulo: 'Guardar Historial',
          subtitulo: 'Mantener registro de diagnósticos',
          valor: viewModel.guardarHistorial,
          onChanged: viewModel.toggleGuardarHistorial,
          icono: Icons.history,
        ),
      ],
    );
  }

  /// Construye los botones de acción (guardar, cancelar)
  Widget _construirBotonesAccion(BuildContext context, ConfiguracionViewModel viewModel) {
    return Column(
      children: [
        // Botón guardar cambios
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: viewModel.hayCambios
                ? () => _guardarCambios(context, viewModel)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              disabledBackgroundColor: Colors.white.withOpacity(0.3),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E86AB)),
                    ),
                  )
                : Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      color: viewModel.hayCambios ? const Color(0xFF2E86AB) : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Botón cancelar
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => _cancelarCambios(context, viewModel),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper para construir una sección con título e icono
  Widget _construirSeccion({
    required String titulo,
    required IconData icono,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: const Color(0xFF2E86AB)),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E86AB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  /// Helper para construir campos de texto
  Widget _construirCampoTexto({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required IconData icono,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono, color: const Color(0xFF2E86AB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2E86AB), width: 2),
        ),
        filled: readOnly,
        fillColor: readOnly ? Colors.grey[100] : null,
      ),
    );
  }

  /// Helper para construir dropdowns
  Widget _construirDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icono,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isNotEmpty ? value : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono, color: const Color(0xFF2E86AB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2E86AB), width: 2),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null || value.isEmpty ? 'Seleccione una opción' : null,
    );
  }

  /// Helper para construir switch tiles
  Widget _construirSwitchTile({
    required String titulo,
    required String subtitulo,
    required bool valor,
    required ValueChanged<bool> onChanged,
    required IconData icono,
  }) {
    return SwitchListTile(
      title: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitulo),
      value: valor,
      onChanged: onChanged,
      activeColor: const Color(0xFF2E86AB),
      secondary: Icon(icono, color: const Color(0xFF2E86AB)),
    );
  }

  /// Maneja el guardado de cambios
  Future<void> _guardarCambios(BuildContext context, ConfiguracionViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      final exito = await viewModel.guardarCambios();
      
      if (mounted) {
        if (exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configuración guardada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${viewModel.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Maneja la cancelación de cambios
  void _cancelarCambios(BuildContext context, ConfiguracionViewModel viewModel) {
    if (viewModel.hayCambios) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Descartar Cambios'),
            content: const Text('¿Está seguro que desea descartar los cambios realizados?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continuar Editando'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  viewModel.descartarCambios();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Descartar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }
}