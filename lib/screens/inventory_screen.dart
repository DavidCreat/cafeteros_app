import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/adaptive_card.dart';
import '../widgets/adaptive_layout.dart';
import '../utils/responsive_utils.dart';
import '../app.dart';
import '../repositories/data_repository.dart';
import 'lot_register_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final DataRepository _repository = DataRepository();
  List<Map<String, dynamic>> _lotes = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLotes();
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
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LotRegisterScreen()),
            ).then((_) => _loadLotes());
          },
          child: const Icon(Icons.add),
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
                  Icon(Icons.inventory_2, color: Colors.grey.shade700),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Inventario', 
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
            // Inventory list
            if (_filteredLotes.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2, size: 64, color: Colors.grey.shade400),
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
                    return _InventoryItem(
                      name: '${lote['variedad']} - ${lote['estado']}',
                      qty: '${lote['cantidad']} kg',
                      date: lote['fecha'] ?? '',
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

class _InventoryItem extends StatelessWidget {
  final String name;
  final String qty;
  final String date;

  const _InventoryItem({
    required this.name,
    required this.qty,
    this.date = '',
  });

  @override
  Widget build(BuildContext context) {
    // Convertir la fecha ISO a un formato legible si existe
    String formattedDate = '';
    if (date.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(date);
        formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } catch (e) {
        formattedDate = date;
      }
    }
    
    return GestureDetector(
      onTap: () {
        // Extraer la variedad del nombre (formato: 'Variedad - Estado')
        final loteName = name.split(' - ')[0];
        
        // Navegar a la pantalla de lotes con el filtro aplicado
        Navigator.pushNamed(
          context, 
          '/lotes',
          arguments: {'searchQuery': loteName}
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.seashell
              : AppColors.bistre2,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.coffee, color: Theme.of(context).brightness == Brightness.light ? AppColors.liver : AppColors.paleDogwood, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.light ? AppColors.bistre : AppColors.isabelline)),
                  const SizedBox(height: 4),
                  Text(qty, style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? AppColors.coffee : AppColors.beaver, fontSize: 13)),
                  if (formattedDate.isNotEmpty) ...[  
                    const SizedBox(height: 4),
                    Text(
                      'Fecha: $formattedDate',
                      style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? AppColors.coffee : AppColors.beaver, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Theme.of(context).brightness == Brightness.light ? AppColors.beaver : AppColors.champagnePink),
          ],
        ),
      ),
    );
  }
}
