import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/glass_bottom_nav.dart';
import '../widgets/adaptive_layout.dart';
import '../utils/responsive_utils.dart';
import '../app.dart';
import '../repositories/data_repository.dart';
import '../services/connectivity_service.dart';
import 'lot_register_screen.dart';
import 'inventory_register_screen.dart';
import 'inventory_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DataRepository _repository = DataRepository();
  List<Map<String, dynamic>> _lotes = [];
  double _totalInventario = 0;
  int _totalLotes = 0;

  Future<void> _loadLotes() async {
    // Load real data from repository
    _lotes = _repository.getLotes();
    _totalInventario = _repository.getTotalInventario();
    _totalLotes = _repository.getLotesCount();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadLotes();
  }

  Color _getColorByEstado(String estado) {
    switch(estado) {
      case 'Fermentación': return AppColors.coffee;
      case 'Secado': return AppColors.liver;
      case 'Almacenado': return AppColors.beaver;
      case 'Pergamino seco': return AppColors.coffee;
      case 'Verde': return AppColors.liver;
      case 'Tostado': return AppColors.beaver;
      default: return AppColors.beaver;
    }
  }
  
  // Get unique estados from lotes
  List<String> _getUniqueEstados() {
    if (_lotes.isEmpty) return [];
    final estados = _lotes.map((lote) => lote['estado'] as String).toSet().toList();
    return estados;
  }
  
  // Get bar groups for estado chart
  List<BarChartGroupData> _getEstadoBarGroups() {
    if (_lotes.isEmpty) return [];
    
    // Group by estado
    final Map<String, double> estadoTotals = {};
    for (final lote in _lotes) {
      final estado = lote['estado'] as String;
      final cantidad = double.parse(lote['cantidad']!);
      estadoTotals[estado] = (estadoTotals[estado] ?? 0) + cantidad;
    }
    
    // Create bar groups
    final estados = _getUniqueEstados();
    return estados.asMap().entries.map((entry) {
      final index = entry.key;
      final estado = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: estadoTotals[estado] ?? 0,
            color: _getColorByEstado(estado),
            width: 20,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.coffee,
        foregroundColor: Colors.white,
        onPressed: () async {
          // Navigate to lot register screen
          HapticFeedback.mediumImpact();
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LotRegisterScreen()),
          );
          // Reload data when returning from register screen
          _loadLotes();
        },
        child: const Text(
          '+',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: AdaptiveScrollView(
          physics: const BouncingScrollPhysics(),
          children: [
            // Saludo personalizado y estado de conexión
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido, Caficultor!', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: ResponsiveUtils.adaptiveFontSize(context, 22),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.adaptivePadding(context, 4)),
                    Text(
                      'Gestión inteligente de tu inventario', 
                      style: TextStyle(
                        fontSize: ResponsiveUtils.adaptiveFontSize(context, 14), 
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white70,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Indicador de conexión en tiempo real
                StreamBuilder<bool>(
                  stream: ConnectivityService().connectivityStream,
                  initialData: ConnectivityService().isConnected,
                  builder: (context, snapshot) {
                    final isConnected = snapshot.data ?? false;
                    return Row(
                      children: [
                        Icon(
                          isConnected ? Icons.wifi : Icons.wifi_off,
                          color: isConnected ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isConnected ? 'Con conexión' : 'Sin conexión',
                          style: TextStyle(
                            color: isConnected ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Tarjetas de resumen con animación
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 700),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SummaryCard(
                    icon: Icons.inventory_2,
                    label: 'Inv.',
                    value: '${_totalInventario.toStringAsFixed(1)} kg',
                    color: Color(0xFF795548),
                  ),
                  _SummaryCard(
                    icon: Icons.grass,
                    label: 'Lotes',
                    value: _totalLotes.toString(),
                    color: Color(0xFF388E3C),
                  ),
                  _SummaryCard(
                    icon: Icons.attach_money,
                    label: 'Ventas',
                    value: _totalInventario > 0 ? '\$${(_totalInventario * 25000).toStringAsFixed(0)}' : '\$0',
                    color: Color(0xFFD4AF37),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Gráfica circular de variedades
            const Text('Distribución por variedad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8), // Espacio adicional entre el título y el gráfico
            SizedBox(
              height: 80, // Reducido de 100 a 80
              child: _lotes.isEmpty
                ? Center(child: Text('No hay datos disponibles', style: TextStyle(color: Colors.grey)))
                : PieChart(
                  PieChartData(
                    sections: _lotes.map((lote) {
                        return PieChartSectionData(
                          value: double.parse(lote['cantidad']!),
                          color: _getColorByEstado(lote['estado']!),
                          title: lote['variedad'],
                          titleStyle: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.white),
                          radius: 30, // Reducido de 35 a 30
                          titlePositionPercentageOffset: 0.7,
                        );
                      }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        if (response != null && response.touchedSection != null && event is FlTapUpEvent) {
                          final section = response.touchedSection!.touchedSection;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Variedad: ${section?.title ?? 'N/A'}, Cantidad: ${section?.value.toStringAsFixed(1) ?? '0'} kg')),
                          );
                        }
                      },
                    ),
                  ),
                ),
            ),
            const SizedBox(height: 28),
            // Gráfica de barras por estado
            const Text('Distribución por estado (kg)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(
              height: 180,
              child: _lotes.isEmpty
                ? Center(child: Text('No hay datos disponibles', style: TextStyle(color: Colors.grey)))
                : BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final estados = _getUniqueEstados();
                            if (value.toInt() < estados.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  estados[value.toInt()],
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    barGroups: _getEstadoBarGroups(),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.brown.shade100,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            'Estado: ${_getUniqueEstados()[group.x.toInt()]}\nCantidad: ${rod.toY.toStringAsFixed(1)} kg',
                            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ),
            const SizedBox(height: 24),
            // Dashboard grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _DashboardTile(
                  icon: Icons.inventory,
                  label: 'Inventario',
                  description: 'Controla tu inventario de café',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InventoryRegisterScreen(),
                      ),
                    ).then((_) => _loadLotes());
                  },
                ),
                _DashboardTile(
                  icon: Icons.grass,
                  label: 'Lotes',
                  description: 'Gestiona tus lotes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InventoryScreen(),
                      ),
                    ).then((_) => _loadLotes());
                  },
                ),
                _DashboardTile(
                  icon: Icons.bar_chart,
                  label: 'Estadísticas',
                  description: 'Visualiza tu producción',
                ),
                _DashboardTile(
                  icon: Icons.person,
                  label: 'Perfil',
                  description: 'Tu información personal',
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 0,
        onTap: (idx) {
          // Usar el método de navegación global definido en app.dart
          final appState = context.findAncestorStateOfType<InventarioCafeteroAppState>();
          if (appState != null) {
            appState.navigateToScreen(idx);
          }
        },
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback? onTap;

  const _DashboardTile({
    required this.icon,
    required this.label,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.coffee, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para las tarjetas de resumen
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
