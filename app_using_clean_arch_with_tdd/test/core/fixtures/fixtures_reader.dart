//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'dart:io';

Future<String> fixture(String fileName) async => await File('test/core/fixtures/$fileName').readAsString();