import 'package:bili/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> topProvider = [
  ChangeNotifierProvider(create: (_) => ThemeProvider()),
];
