import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:inventory/services/api/api_constants.dart';
import 'package:inventory/models/item.dart';
import 'package:inventory/models/constants.dart';
import 'package:inventory/services/api/auth_service.dart';
import 'package:inventory/services/api/item_service.dart';
import 'package:mime/mime.dart';

class ItemApiService implements ItemService {
  final AuthService _authService;

  ItemApiService(this._authService);

  List<Item> _items = [];
  List<Item> _trash = [];
  double _scrollPos = 0;

  double getScrollPos() {
    return _scrollPos;
  }

  void setScrollPos(double currentScrollPos) {
    _scrollPos = currentScrollPos;
  }

  AuthService get authService {
    return _authService;
  }

  List<Item> get getItems {
    return List.from(_items);
  }

  List<Item> get getTrash {
    return List.from(_trash);
  }

  void removeTrashItem(String trashItemId) {
    _trash.removeWhere((element) => element.id == trashItemId);
  }

  void _itemToTrash(Item item) {
    _trash.add(item);
  }

  void _itemToList(Item item) {
    final _item = _items.firstWhere((element) => element.id == item.id,
        orElse: () => null);
    if (_item != null) {
      _items[_items.indexOf(_item)] = item;
    }
  }

  @override
  Future<List<Item>> fetchItems() async {
    final String request = ApiConstants.AUTH_PATH + _authService.user.token;
    final response = await http.get(request).timeout(longDuration);
    if (response.statusCode == HttpStatus.ok) {
      final List<Item> fetchedItemList = [];
      final Map<String, dynamic> itemListData = json.decode(response.body);
      if (itemListData == null) return [];
      itemListData.forEach((String itemId, dynamic itemData) {
        itemData['id'] = itemId;
        Item item = Item.fromJson(itemData);
        fetchedItemList.add(item);
      });
      _items = fetchedItemList;
      return fetchedItemList;
    } else {
      throw Exception('Loading data error');
    }
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final uriPath = ApiConstants.URI_PATH;
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(uriPath));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    print(DateTime.now().toString() +
        ' uploadImage' +
        _authService.user.toString() +
        '  ' +
        _authService.hashCode.toString());
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authService.user.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      throw Exception('Problem updating image');
    }
  }

  Future<void> updateItem(Item item, File imageFile) async {
    final _user = _authService.user;
    final _newItem = item.id == null || item.id == '';
    Map<String, dynamic> uploadData = {};
    String imageUrl = item.imageUrl;
    String imagePath = item.imagePath;
    if (imageFile != null) {
      uploadData = await uploadImage(imageFile);
      if (uploadData == null) {
        return;
      }
      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }
    Map<String, dynamic> updateData = {
      'userId': _user.id,
      'name': item.name,
      'note': item.note,
      'quantity': item.quantity,
      'userEmail': _user.email,
      'imagePath': uploadData.length > 0 ? uploadData['imagePath'] : imagePath,
      'imageUrl': uploadData.length > 0 ? uploadData['imageUrl'] : imageUrl,
      'qrCode': item.qrCode ?? '',
      'location': (item.location != null)
          ? {
              'longitude': (item.location.longitude != null)
                  ? item.location.longitude
                  : 0.0,
              'latitude': (item.location.latitude != null)
                  ? item.location.latitude
                  : 0.0,
              'address':
                  (item.location.address != null) ? item.location.address : '',
            }
          : null,
    };
    try {
      final http.Response response = _newItem
          ? await http.post(ApiConstants.AUTH_PATH + _user.token,
              body: json.encode(updateData))
          : await http.put(
              'https://${ApiConstants.PROJECT_NAME}.firebaseio.com/items/${item.id}.json?auth=${_user.token}',
              body: json.encode(updateData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Item updatedItem = Item(
          id: _newItem ? responseData['name'] : item.id,
          name: item.name,
          note: item.note,
          imageUrl: uploadData.length > 0 ? uploadData['imageUrl'] : imageUrl,
          imagePath:
              uploadData.length > 0 ? uploadData['imagePath'] : imagePath,
          quantity: item.quantity,
          qrCode: item.qrCode,
          location: item.location,
          userEmail: _user.email,
          userId: _user.id);
      if (_newItem)
        _items.add(updatedItem);
      else {
        _itemToList(updatedItem);
      }
    } catch (error) {
      throw Exception('Problem updating data');
    }
  }

  Future<void> deleteItem(Item item) {
    final deletedItemId = item.id;
    _itemToTrash(item);
    _items.removeWhere((element) => (element.id == deletedItemId));
    return http
        .delete(
            'https://${ApiConstants.PROJECT_NAME}.firebaseio.com/items/$deletedItemId.json?auth=${_authService.user.token}')
        .then((http.Response response) {
      return;
    }).catchError((error) {
      return;
    });
  }
}
