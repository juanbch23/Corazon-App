import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class DiagnosticoScreen extends StatefulWidget {
  const DiagnosticoScreen({super.key});

  @override
  State<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends State<DiagnosticoScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  
  // Controladores para campos de texto
  final _edadController = TextEditingController();
  final _psController = TextEditingController();
  final _pdController = TextEditingController();
  final _colesterolController = TextEditingController();
  final _glucosaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();
  
  // Variables para dropdowns
  String? _genero;
  String? _fuma;
  String? _alcohol;
  String? _actividad;
  
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _edadController.dispose();
    _psController.dispose();
    _pdController.dispose();
    _colesterolController.dispose();
    _glucosaController.dispose();
    _pesoController.dispose();
    _estaturaController.dispose();
    super.dispose();
  }

  Future<void> _enviarDiagnostico() async {
    if (!_formKey.currentState!.validate() || !_validarCampos()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final formData = {
        'edad': int.parse(_edadController.text),
        'genero': _genero,
        'ps': int.parse(_psController.text),
        'pd': int.parse(_pdController.text),
        'colesterol': double.parse(_colesterolController.text),
        'glucosa': double.parse(_glucosaController.text),
        'fuma': _fuma,
        'alcohol': _alcohol,
        'actividad': _actividad,
        'peso': double.parse(_pesoController.text),
        'estatura': double.parse(_estaturaController.text),
      };

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await _apiService.diagnosticar(formData, 
        username: authProvider.username
      );
      
      if (mounted) {
        // Navegar a resultados con los datos
        context.push('/resultados', extra: {
          'riesgo': response['riesgo'],
          'confianza': response['confianza'],
          'fecha': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validarCampos() {
    if (_genero == null) {
      setState(() => _error = 'Debe seleccionar un género');
      return false;
    }
    if (_fuma == null) {
      setState(() => _error = 'Debe seleccionar si fuma o no');
      return false;
    }
    if (_alcohol == null) {
      setState(() => _error = 'Debe seleccionar si toma alcohol o no');
      return false;
    }
    if (_actividad == null) {
      setState(() => _error = 'Debe seleccionar un nivel de actividad');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Evaluación Médica'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.medical_services,
                        size: 48,
                        color: Colors.orange.shade600,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Evaluación Cardiovascular',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete todos los campos para obtener su diagnóstico',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Error message
              if (_error != null)
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_error != null) const SizedBox(height: 16),

              // Campos del formulario en grid
              _buildSectionCard(
                'Datos Básicos',
                Icons.person,
                [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _edadController,
                          label: 'Edad',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Género',
                          value: _genero,
                          items: const [
                            {'value': 'masculino', 'label': 'Masculino'},
                            {'value': 'femenino', 'label': 'Femenino'},
                          ],
                          onChanged: (value) => setState(() => _genero = value),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _pesoController,
                          label: 'Peso (kg)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _estaturaController,
                          label: 'Estatura (cm)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              _buildSectionCard(
                'Presión Arterial',
                Icons.favorite,
                [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _psController,
                          label: 'Presión Sistólica',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _pdController,
                          label: 'Presión Diastólica',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              _buildSectionCard(
                'Análisis de Laboratorio',
                Icons.science,
                [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _colesterolController,
                          label: 'Colesterol',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _glucosaController,
                          label: 'Glucosa',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              _buildSectionCard(
                'Hábitos de Vida',
                Icons.health_and_safety,
                [
                  _buildDropdown(
                    label: '¿Fuma?',
                    value: _fuma,
                    items: const [
                      {'value': 's', 'label': 'Sí'},
                      {'value': 'n', 'label': 'No'},
                    ],
                    onChanged: (value) => setState(() => _fuma = value),
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: '¿Toma alcohol?',
                    value: _alcohol,
                    items: const [
                      {'value': 's', 'label': 'Sí'},
                      {'value': 'n', 'label': 'No'},
                    ],
                    onChanged: (value) => setState(() => _alcohol = value),
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: 'Nivel de actividad física',
                    value: _actividad,
                    items: const [
                      {'value': 'ninguna', 'label': 'Ninguna'},
                      {'value': '1-2 veces', 'label': '1-2 veces/semana'},
                      {'value': '3 o más veces', 'label': '3 o más veces/semana'},
                    ],
                    onChanged: (value) => setState(() => _actividad = value),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Botón de diagnóstico
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _enviarDiagnostico,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.analytics, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Obtener Diagnóstico',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.orange.shade500),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es requerido';
        }
        if (keyboardType == TextInputType.number) {
          if (double.tryParse(value) == null) {
            return 'Debe ser un número válido';
          }
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.orange.shade500),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Text(item['label']!),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Debe seleccionar una opción';
        }
        return null;
      },
    );
  }
}
