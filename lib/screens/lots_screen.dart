import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/adaptive_card.dart';
import '../widgets/adaptive_layout.dart';
import '../utils/responsive_utils.dart';
import '../app.dart';
import '../repositories/data_repository.dart';
import '../widgets/info_item.dart';
import 'lot_register_screen.dart';

class LotsScreen extends StatefulWidget {
  final String? initialSearchQuery;
  
  const LotsScreen({super.key, this.initialSearchQuery});

  @override
  State<LotsScreen> createState() => _LotsScreenState();
}

class _LotsScreenState extends State<LotsScreen> {
  final DataRepository _repository = DataRepository();
  List<Map<String, dynamic>> _lotes = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLotes();
    
    // Aplicar el filtro inicial si existe
    if (widget.initialSearchQuery != null && widget.initialSearchQuery!.isNotEmpty) {
      setState(() {
        _searchQuery = widget.initialSearchQuery!;
        _searchController.text = widget.initialSearchQuery!;
      });
    }
  }

  Future<void> _loadLotes() async {
    setState(() {
      _lotes = _repository.getLotes();
    });
  }

  List<Map<String, dynamic>> get _filteredLotes {
    if (_searchQuery.isEmpty) return _lotes;
    return _lotes.where((lote) {
      return lote['variedad'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
             lote['estado'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0), // Aumentar padding para elevar más el botón
        child: FloatingActionButton(
          backgroundColor: AppColors.coffee,
          foregroundColor: Colors.white,
          onPressed: () async {
            HapticFeedback.mediumImpact();
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LotRegisterScreen()),
            );
            _loadLotes();
          },
          child: const Text(
            '+',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: AdaptiveScrollView(
          physics: const BouncingScrollPhysics(),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Icon(Icons.grass, color: Colors.grey.shade700),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Lotes registrados', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 28, 
                  color: Theme.of(context).brightness == Brightness.light ? AppColors.bistre : AppColors.isabelline
                )
              ),
            ),
            const SizedBox(height: 16),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AdaptiveCard(
                margin: EdgeInsets.only(bottom: ResponsiveUtils.adaptivePadding(context, 16)),
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.seashell
                    : AppColors.bistre2,
                borderRadius: BorderRadius.circular(ResponsiveUtils.adaptivePadding(context, 16)),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar lote',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),
            // Lotes list
            if (_filteredLotes.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.grass, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No hay lotes registrados',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Presiona el botón + para agregar un nuevo lote',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredLotes.length,
                  itemBuilder: (context, index) {
                    final lote = _filteredLotes[index];
                    return _LotCard(
                      name: lote['variedad'],
                      date: lote['fecha'] ?? '',
                      state: lote['estado'],
                      quantity: '${lote['cantidad']} kg',
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LotCard extends StatelessWidget {
  final String name;
  final String date;
  final String state;
  final String quantity;

  const _LotCard({
    required this.name,
    required this.date,
    required this.state,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    // Convertir la fecha ISO a un formato legible si existe
    String formattedDate = date;
    if (date.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(date);
        formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } catch (e) {
        // Si hay error al parsear, mantener la fecha original
      }
    }
    
    // Determinar el color según el estado del lote
    Color stateColor;
    if (state.toLowerCase().contains('pergamino')) {
      stateColor = Colors.amber.shade800;
    } else if (state.toLowerCase().contains('verde')) {
      stateColor = Colors.green.shade700;
    } else if (state.toLowerCase().contains('tostado')) {
      stateColor = Colors.brown.shade700;
    } else {
      stateColor = AppColors.coffee;
    }
    
    return AdaptiveCard(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.adaptivePadding(context, 16)),
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF2D2926),
      borderRadius: BorderRadius.circular(ResponsiveUtils.adaptivePadding(context, 16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                      stateColor.r.toInt(),
                      stateColor.g.toInt(),
                      stateColor.b.toInt(),
                      0.2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.grass, color: stateColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lote de $name',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: stateColor),
                          const SizedBox(width: 4),
                          Text(
                            'Registrado: $formattedDate',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                      stateColor.r.toInt(),
                      stateColor.g.toInt(),
                      stateColor.b.toInt(),
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    quantity,
                    style: TextStyle(fontWeight: FontWeight.bold, color: stateColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoItem(icon: Icons.coffee, label: 'Variedad', value: name),
                InfoItem(icon: Icons.inventory_2, label: 'Estado', value: state),
                InfoItem(icon: Icons.scale, label: 'Cantidad', value: quantity),
              ],
            ),
            // Espacio para información adicional si es necesario
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
