import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/glass_bottom_nav.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF795548),
        icon: const Icon(Icons.add),
        label: const Text('Registrar nuevo lote'),
        onPressed: () {
          // Aquí iría la navegación real
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Función para registrar lote (demo)')),
          );
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            // Saludo personalizado y estado de conexión
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('¡Bienvenido, Caficultor!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                    SizedBox(height: 4),
                    Text('Gestión inteligente de tu inventario', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  ],
                ),
                const Spacer(),
                // Indicador de conexión
                Row(
                  children: const [
                    Icon(Icons.wifi_off, color: Colors.red, size: 18),
                    SizedBox(width: 4),
                    Text('Sin conexión', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Tarjetas de resumen con animación
            AnimatedOpacity(
              opacity: 1,
              duration: Duration(milliseconds: 700),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SummaryCard(
                    icon: Icons.inventory_2,
                    label: 'Inventario',
                    value: '120 kg',
                    color: Color(0xFF795548),
                  ),
                  _SummaryCard(
                    icon: Icons.grass,
                    label: 'Lotes',
                    value: '8',
                    color: Color(0xFF388E3C),
                  ),
                  _SummaryCard(
                    icon: Icons.attach_money,
                    label: 'Ventas',
                    value: '\$2.3M',
                    color: Color(0xFFD4AF37),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Gráfica circular de variedades
            const Text('Distribución por variedad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(value: 40, color: Color(0xFF795548), title: 'Castillo'),
                    PieChartSectionData(value: 35, color: Color(0xFF8D6E63), title: 'Colombia'),
                    PieChartSectionData(value: 25, color: Color(0xFFD7CCC8), title: 'Tabi'),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      if (response != null && response.touchedSection != null) {
                        final section = response.touchedSection!.touchedSection;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Variedad: ${section?.title ?? 'N/A'}, Cantidad: ${section?.value?.toStringAsFixed(0) ?? '0'} kg')),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Gráfica de barras de producción
            const Text('Producción reciente (kg)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(
              height: 180,
              child: BarChart(
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
                          const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
                          return Text(dias[value.toInt() % 7], style: TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 12, color: Color(0xFF795548))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 17, color: Color(0xFF8D6E63))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 9, color: Color(0xFFD7CCC8))]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 14, color: Color(0xFF388E3C))]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 15, color: Color(0xFFD4AF37))]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 8, color: Color(0xFF795548))]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 13, color: Color(0xFF8D6E63))]),
                  ],
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.brown.shade100,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          'Día: ${group.x + 1}\nProducción: ${rod.toY} kg',
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
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: const [
                _DashboardTile(
                  icon: Icons.inventory_2,
                  label: 'Inventario',
                  description: 'Controla tu inventario de café',
                ),
                _DashboardTile(
                  icon: Icons.grass,
                  label: 'Lotes',
                  description: 'Gestiona tus lotes registrados',
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
            // Search bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 0,
        onTap: (idx) {
          // TODO: implementar navegación global
        },
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  const _DashboardTile({required this.icon, required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: Colors.black87),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para las tarjetas de resumen
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _SummaryCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}
