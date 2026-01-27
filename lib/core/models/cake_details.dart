class CakeDetails {
  final String size;
  final String flavor;
  final String design;
  
  CakeDetails({
    required this.size,
    required this.flavor,
    required this.design,
  });
  
  @override
  String toString() {
    return '$size $flavor cake with $design design';
  }
}
