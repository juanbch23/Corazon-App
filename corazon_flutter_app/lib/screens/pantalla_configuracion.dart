import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class PantallaConfiguracion extends StatefulWidget {
  const PantallaConfiguracion({super.key});

  @override
  State<PantallaConfiguracion> createState() => _PantallaConfiguracionState();
}

class _PantallaConfiguracionState extends State<PantallaConfiguracion> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _servicioApi = ApiService();
  
  bool _estaCargando = true;
  bool _estaActualizando = false;
  String? _mensajeError;
  String? _mensajeExito;
  
  // Controladores para los campos del formulario
  final _controladorNombre = TextEditingController();
  final _controladorApellido = TextEditingController();
  final _controladorFechaNacimiento = TextEditingController();
  final _controladorTelefono = TextEditingController();
  final _controladorDireccion = TextEditingController();
  final _controladorDni = TextEditingController();
  
  String? _generoSeleccionado;
  DateTime? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  @override
  void dispose() {
    _controladorNombre.dispose();
    _controladorApellido.dispose();
    _controladorFechaNacimiento.dispose();
    _controladorTelefono.dispose();
    _controladorDireccion.dispose();
    _controladorDni.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosUsuario() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final respuesta = await _servicioApi.obtenerConfiguracion(
        username: authProvider.username
      );
      
      setState(() {
        _controladorNombre.text = respuesta['nombre'] ?? '';
        _controladorApellido.text = respuesta['apellido'] ?? '';
        _controladorTelefono.text = respuesta['telefono'] ?? '';
        _controladorDireccion.text = respuesta['direccion'] ?? '';
        _controladorDni.text = respuesta['dni'] ?? '';
        
        // Convertir género del backend (M/F) a formato frontend (masculino/femenino)
        final generoBackend = respuesta['genero'] as String?;
        if (generoBackend == 'M') {
          _generoSeleccionado = 'masculino';
        } else if (generoBackend == 'F') {
          _generoSeleccionado = 'femenino';
        } else {
          _generoSeleccionado = null;
        }
        
        if (respuesta['fecha_nacimiento'] != null && respuesta['fecha_nacimiento'].isNotEmpty) {
          try {
            // Intentar parsear diferentes formatos de fecha
            String fechaStr = respuesta['fecha_nacimiento'];
            DateTime fecha;
            
            if (fechaStr.contains('GMT') || fechaStr.contains(',')) {
              // Formato RFC2822: "Wed, 23 Aug 2000 00:00:00 GMT"
              // Extraer solo la parte de la fecha
              final regex = RegExp(r'(\d{1,2})\s+(\w{3})\s+(\d{4})');
              final match = regex.firstMatch(fechaStr);
              if (match != null) {
                final day = match.group(1)!;
                final monthStr = match.group(2)!;
                final year = match.group(3)!;
                
                // Convertir mes de texto a número
                final meses = {
                  'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
                  'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
                  'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
                };
                final month = meses[monthStr] ?? '01';
                
                // Crear fecha en formato ISO
                fecha = DateTime.parse('$year-$month-${day.padLeft(2, '0')}');
              } else {
                // Fallback: usar fecha actual menos 25 años
                fecha = DateTime.now().subtract(const Duration(days: 365 * 25));
              }
            } else if (fechaStr.contains('-')) {
              // Formato: "2000-08-23"
              fecha = DateTime.parse(fechaStr);
            } else {
              // Intentar formato estándar
              fecha = DateTime.parse(fechaStr);
            }
            
            _fechaSeleccionada = fecha;
            _controladorFechaNacimiento.text = 
              '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
          } catch (e) {
            print('Error parseando fecha: $e');
            // Si no se puede parsear, usar fecha por defecto
            _fechaSeleccionada = null;
            _controladorFechaNacimiento.text = '';
          }
        }
        
        _estaCargando = false;
      });
    } catch (e) {
      setState(() {
        _mensajeError = 'No se pudo cargar la información: $e';
        _estaCargando = false;
      });
    }
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fechaElegida = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    
    if (fechaElegida != null && fechaElegida != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = fechaElegida;
        _controladorFechaNacimiento.text = 
          '${fechaElegida.year}-${fechaElegida.month.toString().padLeft(2, '0')}-${fechaElegida.day.toString().padLeft(2, '0')}';
      });
    }
  }

  bool _validarCampos() {
    if (_controladorNombre.text.isEmpty ||
        _controladorApellido.text.isEmpty ||
        _controladorFechaNacimiento.text.isEmpty ||
        _generoSeleccionado == null ||
        _controladorTelefono.text.isEmpty ||
        _controladorDireccion.text.isEmpty ||
        _controladorDni.text.isEmpty) {
      setState(() {
        _mensajeError = 'Todos los campos son obligatorios';
        _mensajeExito = null;
      });
      return false;
    }
    
    if (_controladorDni.text.length != 8) {
      setState(() {
        _mensajeError = 'El DNI debe tener exactamente 8 dígitos';
        _mensajeExito = null;
      });
      return false;
    }
    
    setState(() {
      _mensajeError = null;
    });
    return true;
  }

  Future<void> _actualizarDatos() async {
    if (!_formKey.currentState!.validate() || !_validarCampos()) {
      return;
    }

    setState(() {
      _estaActualizando = true;
      _mensajeError = null;
      _mensajeExito = null;
    });

    try {
      // Convertir género al formato del backend (masculino -> M, femenino -> F)
      String? generoBackend;
      if (_generoSeleccionado == 'masculino') {
        generoBackend = 'M';
      } else if (_generoSeleccionado == 'femenino') {
        generoBackend = 'F';
      }
      
      final datos = {
        'nombre': _controladorNombre.text.trim(),
        'apellido': _controladorApellido.text.trim(),
        'fecha_nacimiento': _controladorFechaNacimiento.text,
        'genero': generoBackend,
        'telefono': _controladorTelefono.text.trim(),
        'direccion': _controladorDireccion.text.trim(),
        'dni': _controladorDni.text.trim(),
      };

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final respuesta = await _servicioApi.actualizarConfiguracion(
        datos,
        username: authProvider.username
      );
      
      setState(() {
        _mensajeExito = respuesta['message'] ?? 'Datos actualizados correctamente';
        _estaActualizando = false;
      });
      
    } catch (e) {
      setState(() {
        _mensajeError = e.toString();
        _mensajeExito = null;
        _estaActualizando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Usuario'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        leading: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (authProvider.isAdmin) {
                  context.go('/admin');
                } else {
                  context.go('/home');
                }
              },
            );
          },
        ),
      ),
      body: _estaCargando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando información...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icono de configuración
                    Icon(
                      Icons.settings,
                      size: 80,
                      color: Colors.orange.shade600,
                    ),
                    const SizedBox(height: 24),
                    
                    Text(
                      'Configuración Personal',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Mensajes de error y éxito
                    if (_mensajeError != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red.shade600, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _mensajeError!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    if (_mensajeExito != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _mensajeExito!,
                                style: TextStyle(color: Colors.green.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Formulario en grid
                    _construirFormulario(),
                    
                    const SizedBox(height: 32),
                    
                    // Botón de actualizar
                    ElevatedButton(
                      onPressed: _estaActualizando ? null : _actualizarDatos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _estaActualizando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Actualizar Datos',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Botón para volver al inicio
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return OutlinedButton(
                          onPressed: () {
                            if (authProvider.isAdmin) {
                              context.go('/admin');
                            } else {
                              context.go('/home');
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange.shade600,
                            side: BorderSide(color: Colors.orange.shade600),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Volver al Inicio'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _construirFormulario() {
    return Column(
      children: [
        // Fila 1: Nombre y Apellido
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controladorNombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _controladorApellido,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Fila 2: Fecha de nacimiento y Género
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controladorFechaNacimiento,
                readOnly: true,
                onTap: _seleccionarFecha,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _generoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'femenino', child: Text('Femenino')),
                ],
                onChanged: (valor) {
                  setState(() {
                    _generoSeleccionado = valor;
                  });
                },
                validator: (valor) {
                  if (valor == null) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Fila 3: Teléfono y DNI
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controladorTelefono,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _controladorDni,
                keyboardType: TextInputType.number,
                maxLength: 8,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'DNI',
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Requerido';
                  }
                  if (valor.length != 8) {
                    return '8 dígitos';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Fila 4: Dirección (campo completo)
        TextFormField(
          controller: _controladorDireccion,
          decoration: const InputDecoration(
            labelText: 'Dirección',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
          validator: (valor) {
            if (valor == null || valor.isEmpty) {
              return 'Requerido';
            }
            return null;
          },
        ),
      ],
    );
  }
}
