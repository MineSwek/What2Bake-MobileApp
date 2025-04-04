library;

import 'package:pocketbase/pocketbase.dart';
final pb = PocketBase('https://w2b.poneciak.com/pb');
late RecordModel pbUserData;
bool isLogged = false;
bool theme = false;
List<bool> ingredientsChange = [false, false, false, false];
