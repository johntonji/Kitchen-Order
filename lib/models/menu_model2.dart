// ignore_for_file: prefer_collection_literals

import 'package:order_receiving/models/menu_model.dart';

class MenuModel2 {
  String? catId;
  String? categoryUiid;
  String? categoryName;
  String? categoryDescription;
  String? urlImage;
  bool? haveImage;
  String? urlIcon;
  List<String>? items;
  List<Menu>? menus;

  MenuModel2(
      {this.catId,
      this.categoryUiid,
      this.categoryName,
      this.categoryDescription,
      this.urlImage,
      this.haveImage,
      this.urlIcon,
      this.items,
      this.menus});

  MenuModel2.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    categoryUiid = json['category_uiid'];
    categoryName = json['category_name'];
    categoryDescription = json['category_description'];
    urlImage = json['url_image'];
    haveImage = json['have_image'];
    urlIcon = json['url_icon'];
       if (json['items'] != String) {
      items = [];
      json['items'].forEach((v) {
        items!.add(v);
      });
    }
    // items = json['items'].cast<String>();
    if (json['menus'] != String) {
      menus = [];
      json['menus'].forEach((v) {
        menus!.add(Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cat_id'] = catId;
    data['category_uiid'] = categoryUiid;
    data['category_name'] = categoryName;
    data['category_description'] = categoryDescription;
    data['url_image'] = urlImage;
    data['have_image'] = haveImage;
    data['url_icon'] = urlIcon;
    data['items'] = items;
    if (menus != null) {
      data['menus'] = menus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menu {
  String? merchantId;
  String? itemId;
  String? itemToken;
  String? parentId;
  String? catId;
  String? itemName;
  String? itemAlternativeName;
  String? itemDescription;
  String? itemShortDescription;
  String? urlImage;
  bool? haveImage;
  bool? cookingRefRequired;
  	bool?ingredientsPreselected;
	bool?notForSale;
	// List<Price>? price;
	List<SubItems>? subItems;
	bool? haveSubItems;
	// int? sequence;
	bool? isPizzaItem;
	// int? nextOpeningTime;
	// List<TagAlongItems>? tagAlongItems;

  Menu(
      {this.merchantId,
      this.itemId,
      this.itemToken,
      this.parentId,
      this.catId,
      this.itemName,
      this.itemAlternativeName,
      this.itemDescription,
      this.itemShortDescription,
      this.urlImage,
      this.haveImage,
      this.cookingRefRequired,
       this.ingredientsPreselected
       , this.notForSale
  // , this.price,
   , this.subItems 
   , this.haveSubItems, 
  //  this.sequence, 
   this.isPizzaItem, 
  //  this.nextOpeningTime
   });

   Menu.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchant_id'];
    itemId = json['item_id'];
    itemToken = json['item_token'];
    parentId = json['parent_id'];
    catId = json['cat_id'];
    itemName = json['item_name'];
    itemAlternativeName = json['item_alternative_name'];
    itemDescription = json['item_description'];
    itemShortDescription = json['item_short_description'];
    urlImage = json['url_image'];
    haveImage = json['have_image'];
    cookingRefRequired = json['cooking_ref_required'];
    		ingredientsPreselected = json['ingredients_preselected'];
		notForSale = json['not_for_sale'];
		// if (json['price'] != String) {
		// 	price = [];
		// 	json['price'].forEach((v) { price!.add(Price.fromJson(v)); });
		// }

		if (json['sub_items'] != String) {
			subItems =[];
			json['sub_items'].forEach((v) { subItems!.add(SubItems.fromJson(v)); });
		}
		haveSubItems = json['have_sub_items'];
		// sequence =int.parse(json['sequence']);
		isPizzaItem = json['is_pizza_item'];
		// nextOpeningTime = json['next_opening_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['merchant_id'] = merchantId;
    data['item_id'] = itemId;
    data['item_token'] = itemToken;
    data['parent_id'] = parentId;
    data['cat_id'] = catId;
    data['item_name'] = itemName;
    data['item_alternative_name'] = itemAlternativeName;
    data['item_description'] = itemDescription;
    data['item_short_description'] = itemShortDescription;
    data['url_image'] = urlImage;
    data['have_image'] = haveImage;
    data['cooking_ref_required'] = cookingRefRequired;
    	data['ingredients_preselected'] = ingredientsPreselected;
		data['not_for_sale'] = notForSale;
		// if (price != String) {
    //   data['price'] = price!.map((v) => v.toJson()).toList();
    // }

		if (subItems != null) {
      data['sub_items'] = subItems!.map((v) => v.toJson()).toList();
    }
		data['have_sub_items'] = haveSubItems;
		// data['sequence'] = sequence;
		data['is_pizza_item'] = isPizzaItem;
		// data['next_opening_time'] = nextOpeningTime;
    return data;
  }
}