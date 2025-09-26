import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../vistamodelos/diagnostico_viewmodel.dart';
import '../modelos/diagnostico_cardiovascular.dart';

// Vista principal de Diagnóstico siguiendo el patrón MVVM
class DiagnosticoVista extends StatefulWidget {
  const DiagnosticoVista({Key? key}) : super(key: key);

  @override
  State<DiagnosticoVista> createState() => _DiagnosticoVistaState();
}

class _DiagnosticoVistaState extends State<DiagnosticoVista> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos del formulario
  final _edadController = TextEditingController();
  final _presionSistolicaController = TextEditingController();
  final _presionDiastolicaController = TextEditingController();
  final _colesterolController = TextEditingController();
  final _frecuenciaCardiacaController = TextEditingController();
  
  // Variables para los campos de selección
  String? _sexoSeleccionado;
  String? _tipoDolorPechoSeleccionado;
  String? _azucarEnSangreSeleccionado;
  String? _electrocardiogramaSeleccionado;
  String? _anginaSeleccionado;
  String? _pendienteSeleccionado;
  String? _talasemiaSeleccionado;

  @override
  void initState() {
    super.initState();
    // Cargar historial al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiagnosticoViewModel>().cargarHistorialResultados();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico Cardiovascular'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _mostrarHistorial(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _cerrarSesion(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 60,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Evaluación de Riesgo Cardiovascular',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete los siguientes datos para realizar la evaluación',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Sección de datos personales
              _construirSeccion(
                'Datos Personales',
                [
                  _construirCampoNumerico(
                    'Edad (años)',
                    _edadController,
                    'Ingrese su edad',
                  ),
                  _construirDropdown(
                    'Sexo',
                    _sexoSeleccionado,
                    ['Masculino', 'Femenino'],
                    (valor) => setState(() => _sexoSeleccionado = valor),
                  ),
                ],
              ),
              
              // Sección de presión arterial
              _construirSeccion(
                'Presión Arterial',
                [
                  _construirCampoNumerico(
                    'Presión Sistólica (mmHg)',
                    _presionSistolicaController,
                    'Ej: 120',
                  ),
                  _construirCampoNumerico(
                    'Presión Diastólica (mmHg)',
                    _presionDiastolicaController,
                    'Ej: 80',
                  ),
                ],
              ),
              
              // Sección de análisis clínicos
              _construirSeccion(
                'Análisis Clínicos',
                [
                  _construirCampoNumerico(
                    'Colesterol (mg/dl)',
                    _colesterolController,
                    'Ej: 200',
                  ),
                  _construirDropdown(
                    'Azúcar en Sangre > 120 mg/dl',
                    _azucarEnSangreSeleccionado,
                    ['Sí', 'No'],
                    (valor) => setState(() => _azucarEnSangreSeleccionado = valor),
                  ),
                ],
              ),
              
              // Sección cardiovascular
              _construirSeccion(
                'Evaluación Cardiovascular',
                [
                  _construirCampoNumerico(
                    'Frecuencia Cardíaca Máxima',
                    _frecuenciaCardiacaController,
                    'Ej: 150',
                  ),
                  _construirDropdown(
                    'Tipo de Dolor en el Pecho',
                    _tipoDolorPechoSeleccionado,
                    ['Típico', 'Atípico', 'Sin dolor', 'Asintomático'],
                    (valor) => setState(() => _tipoDolorPechoSeleccionado = valor),
                  ),
                  _construirDropdown(
                    'Electrocardiograma en Reposo',
                    _electrocardiogramaSeleccionado,
                    ['Normal', 'Anormalidad ST-T', 'Hipertrofia ventricular'],
                    (valor) => setState(() => _electrocardiogramaSeleccionado = valor),
                  ),
                  _construirDropdown(
                    'Angina Inducida por Ejercicio',
                    _anginaSeleccionado,
                    ['Sí', 'No'],
                    (valor) => setState(() => _anginaSeleccionado = valor),
                  ),
                  _construirDropdown(
                    'Pendiente del Segmento ST',
                    _pendienteSeleccionado,
                    ['Ascendente', 'Plana', 'Descendente'],
                    (valor) => setState(() => _pendienteSeleccionado = valor),
                  ),
                  _construirDropdown(
                    'Talasemia',
                    _talasemiaSeleccionado,
                    ['Normal', 'Defecto fijo', 'Defecto reversible'],
                    (valor) => setState(() => _talasemiaSeleccionado = valor),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Botón de diagnóstico
              Consumer<DiagnosticoViewModel>(
                builder: (context, viewModel, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: viewModel.estaCargando ? null : _realizarDiagnostico,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                      ),
                      child: viewModel.estaCargando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Realizar Diagnóstico',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  );
                },
              ),
              
              // Mostrar error si existe
              Consumer<DiagnosticoViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.mensajeError != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.red.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  viewModel.mensajeError!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirSeccion(String titulo, List<Widget> campos) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 16),
            ...campos,
          ],
        ),
      ),
    );
  }

  Widget _construirCampoNumerico(
    String etiqueta,
    TextEditingController controlador,
    String ayuda,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controlador,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: etiqueta,
          hintText: ayuda,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          if (double.tryParse(value) == null) {
            return 'Ingrese un número válido';
          }
          return null;
        },
      ),
    );
  }

  Widget _construirDropdown<T>(
    String etiqueta,
    T? valorSeleccionado,
    List<T> opciones,
    Function(T?) alCambiar,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: valorSeleccionado,
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
        ),
        items: opciones.map((T opcion) {
          return DropdownMenuItem<T>(
            value: opcion,
            child: Text(opcion.toString()),
          );
        }).toList(),
        onChanged: alCambiar,
        validator: (value) {
          if (value == null) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  void _realizarDiagnostico() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<DiagnosticoViewModel>();
      
      // Crear objeto con los datos clínicos
      final datosClinicosCardiovasculares = DatosClinicosCardiovasculares(
        edad: int.parse(_edadController.text),
        sexo: _sexoSeleccionado == 'Masculino' ? 1 : 0,
        tipoDolorPecho: _mapearTipoDolorPecho(_tipoDolorPechoSeleccionado!),
        presionArterialReposo: int.parse(_presionSistolicaController.text),
        colesterol: int.parse(_colesterolController.text),
        azucarSangre: _azucarEnSangreSeleccionado == 'Sí' ? 1 : 0,
        electrocardiogramaReposo: _mapearElectrocardiograma(_electrocardiogramaSeleccionado!),
        frecuenciaCardiacaMaxima: int.parse(_frecuenciaCardiacaController.text),
        anginaInducidaEjercicio: _anginaSeleccionado == 'Sí' ? 1 : 0,
        depresionST: 0.0, // Este valor se puede agregar si es necesario
        pendienteSegmentoST: _mapearPendiente(_pendienteSeleccionado!),
        numeroVasosColoreados: 0, // Este valor se puede agregar si es necesario
        talasemia: _mapearTalasemia(_talasemiaSeleccionado!),
      );

      final resultado = await viewModel.realizarDiagnostico(datosClinicosCardiovasculares);
      
      if (mounted) {
        _mostrarResultado(resultado);
      }
    }
  }

  // Métodos auxiliares para mapear valores
  int _mapearTipoDolorPecho(String tipo) {
    switch (tipo) {
      case 'Típico': return 1;
      case 'Atípico': return 2;
      case 'Sin dolor': return 3;
      case 'Asintomático': return 4;
      default: return 1;
    }
  }

  int _mapearElectrocardiograma(String tipo) {
    switch (tipo) {
      case 'Normal': return 0;
      case 'Anormalidad ST-T': return 1;
      case 'Hipertrofia ventricular': return 2;
      default: return 0;
    }
  }

  int _mapearPendiente(String pendiente) {
    switch (pendiente) {
      case 'Ascendente': return 1;
      case 'Plana': return 2;
      case 'Descendente': return 3;
      default: return 1;
    }
  }

  int _mapearTalasemia(String talasemia) {
    switch (talasemia) {
      case 'Normal': return 3;
      case 'Defecto fijo': return 6;
      case 'Defecto reversible': return 7;
      default: return 3;
    }
  }

  void _mostrarResultado(resultado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final riesgo = resultado.probabilidadRiesgo;
        final color = riesgo > 0.5 ? Colors.red : Colors.green;
        final texto = riesgo > 0.5 ? 'ALTO RIESGO' : 'BAJO RIESGO';
        
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.favorite, color: color),
              const SizedBox(width: 8),
              const Text('Resultado del Diagnóstico'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color),
                ),
                child: Column(
                  children: [
                    Text(
                      texto,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Probabilidad: ${(riesgo * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 18,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                riesgo > 0.5 
                  ? 'Se recomienda consultar con un especialista cardiovascular.'
                  : 'Mantener hábitos saludables y controles periódicos.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _limpiarFormulario();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Nuevo Diagnóstico'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarHistorial() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Historial de Diagnósticos'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Consumer<DiagnosticoViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.estaCargando) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (viewModel.historialResultados.isEmpty) {
                  return const Center(
                    child: Text('No hay diagnósticos previos'),
                  );
                }
                
                return ListView.builder(
                  itemCount: viewModel.historialResultados.length,
                  itemBuilder: (context, index) {
                    final resultado = viewModel.historialResultados[index];
                    final riesgo = resultado.probabilidadRiesgo;
                    final color = riesgo > 0.5 ? Colors.red : Colors.green;
                    
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.favorite, color: color),
                        title: Text(
                          riesgo > 0.5 ? 'Alto Riesgo' : 'Bajo Riesgo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        subtitle: Text(
                          'Probabilidad: ${(riesgo * 100).toStringAsFixed(1)}%\n'
                          'Fecha: ${resultado.fecha.toString().substring(0, 19)}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _limpiarFormulario() {
    _edadController.clear();
    _presionSistolicaController.clear();
    _presionDiastolicaController.clear();
    _colesterolController.clear();
    _frecuenciaCardiacaController.clear();
    
    setState(() {
      _sexoSeleccionado = null;
      _tipoDolorPechoSeleccionado = null;
      _azucarEnSangreSeleccionado = null;
      _electrocardiogramaSeleccionado = null;
      _anginaSeleccionado = null;
      _pendienteSeleccionado = null;
      _talasemiaSeleccionado = null;
    });
  }

  void _cerrarSesion() {
    // Aquí puedes agregar lógica para limpiar la sesión
    context.go('/login');
  }

  @override
  void dispose() {
    _edadController.dispose();
    _presionSistolicaController.dispose();
    _presionDiastolicaController.dispose();
    _colesterolController.dispose();
    _frecuenciaCardiacaController.dispose();
    super.dispose();
  }
}