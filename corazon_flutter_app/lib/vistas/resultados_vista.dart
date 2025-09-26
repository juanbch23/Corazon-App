import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../vistamodelos/resultados_viewmodel.dart';
import '../modelos/diagnostico_cardiovascular.dart';

/// Vista de Resultados siguiendo patrón MVVM
class ResultadosVista extends StatefulWidget {
  const ResultadosVista({super.key});

  @override
  State<ResultadosVista> createState() => _ResultadosVistaState();
}

class _ResultadosVistaState extends State<ResultadosVista> {
  @override
  void initState() {
    super.initState();
    // Cargar resultados usando el ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ResultadosViewModel>();
      viewModel.cargarResultados();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        title: const Text('Resultados de Diagnóstico'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Consumer<ResultadosViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.resultados.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay resultados disponibles',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Realiza un diagnóstico para ver los resultados',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/diagnostico'),
                    icon: const Icon(Icons.add),
                    label: const Text('Realizar Diagnóstico'),
                  ),
                ],
              ),
            );
          }

          return _buildResultadosContent(context, viewModel);
        },
      ),
    );
  }

  Widget _buildResultadosContent(BuildContext context, ResultadosViewModel viewModel) {
    final resultado = viewModel.ultimoResultado!;
    final riesgo = resultado.probabilidadRiesgo;
    final nivel = resultado.nivelRiesgo;
    final color = _getColorPorNivel(nivel);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de resultado principal
          Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    _getIconoPorNivel(nivel),
                    size: 64,
                    color: color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Riesgo Cardiovascular',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nivel,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(riesgo * 100).toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Gráfico de riesgo
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nivel de Riesgo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: riesgo * 100,
                            color: color,
                            title: '${(riesgo * 100).toStringAsFixed(1)}%',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: (1 - riesgo) * 100,
                            color: Colors.green.shade300,
                            title: '${((1 - riesgo) * 100).toStringAsFixed(1)}%',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        centerSpaceRadius: 50,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Recomendaciones
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.health_and_safety, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Recomendaciones',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._getRecomendaciones(nivel).map((recomendacion) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recomendacion,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Datos del diagnóstico
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Datos del Diagnóstico',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDatoFila('Fecha:', '${resultado.fecha.day}/${resultado.fecha.month}/${resultado.fecha.year}'),
                  _buildDatoFila('Nivel de Riesgo:', resultado.nivelRiesgo),
                  _buildDatoFila('Probabilidad:', '${(resultado.probabilidadRiesgo * 100).toStringAsFixed(1)}%'),
                  ...resultado.parametrosClinicos.entries.map((entry) => 
                    _buildDatoFila('${entry.key}:', entry.value)
                  ).toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/diagnostico'),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nuevo Diagnóstico'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _compartirResultados(context, resultado),
                  icon: const Icon(Icons.share),
                  label: const Text('Compartir'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDatoFila(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              etiqueta,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Color _getColorPorNivel(String nivel) {
    switch (nivel) {
      case 'Bajo':
        return Colors.green;
      case 'Moderado':
        return Colors.orange;
      case 'Alto':
        return Colors.red;
      case 'Muy Alto':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconoPorNivel(String nivel) {
    switch (nivel) {
      case 'Bajo':
        return Icons.check_circle;
      case 'Moderado':
        return Icons.warning;
      case 'Alto':
        return Icons.error;
      case 'Muy Alto':
        return Icons.dangerous;
      default:
        return Icons.help;
    }
  }

  List<String> _getRecomendaciones(String nivel) {
    switch (nivel) {
      case 'Bajo':
        return [
          'Mantén una dieta equilibrada rica en frutas y verduras',
          'Realiza ejercicio regular (30 minutos, 5 días a la semana)',
          'Mantén un peso saludable',
          'Realiza chequeos médicos regulares',
        ];
      case 'Moderado':
        return [
          'Consulta con un médico para evaluación detallada',
          'Reduce el consumo de sal y grasas saturadas',
          'Incrementa la actividad física gradualmente',
          'Controla el estrés con técnicas de relajación',
          'Evita el tabaco y limita el alcohol',
        ];
      case 'Alto':
      case 'Muy Alto':
        return [
          '⚠️ Consulta URGENTEMENTE con un cardiólogo',
          'Sigue estrictamente las recomendaciones médicas',
          'Considera medicación si es prescrita',
          'Monitorea regularmente la presión arterial',
          'Adopta cambios de estilo de vida inmediatos',
          'Programa revisiones médicas frecuentes',
        ];
      default:
        return ['Consulta con un profesional de la salud'];
    }
  }

  void _compartirResultados(BuildContext context, ResultadoDiagnostico resultado) {
    // Implementar funcionalidad de compartir si es necesario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartir resultado: ${resultado.resumen}'),
      ),
    );
  }
}