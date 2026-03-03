
// // class MenuModel {
// //   List<Menus>? menus;

// //   MenuModel({this.menus});

// //   MenuModel.fromJson(Map<String, dynamic> json) {
// //     if (json['menus'] != String) {
// //       menus = [];
// //       json['menus'].forEach((v) {
// //         menus!.add(Menus.fromJson(v));
// //       });
// //     }
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = Map<String, dynamic>();
// //     if (menus != String) {
// //       data['menus'] = menus?.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }

// class MenuModel {
//   String? catId;
//   String? categoryUiid;
//   String? categoryName;
//   String? categoryDescription;
//   String? urlImage;
//   bool? haveImage;
//   String? urlIcon;
//   List<String>? items;
//   List<Menu>? menus;

//   MenuModel(
//       {this.catId,
//       this.categoryUiid,
//       this.categoryName,
//       this.categoryDescription,
//       this.urlImage,
//       this.haveImage,
//       this.urlIcon,
//       this.items,
//       this.menus});

//   MenuModel.fromJson(Map<String, dynamic> json) {
//     catId = json['cat_id'];
//     categoryUiid = json['category_uiid'];
//     categoryName = json['category_name'];
//     categoryDescription = json['category_description'];
//     urlImage = json['url_image'];
//     haveImage = json['have_image'];
//     urlIcon = json['url_icon'];
//        if (json['items'] != String) {
//       items = [];
//       json['items'].forEach((v) {
//         items!.add(v);
//       });
//     }
//     // items = json['items'].cast<String>();
//     if (json['menus'] != String) {
//       menus = [];
//       json['menus'].forEach((v) {
//         menus!.add(Menu.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['cat_id'] = catId;
//     data['category_uiid'] = categoryUiid;
//     data['category_name'] = categoryName;
//     data['category_description'] = categoryDescription;
//     data['url_image'] = urlImage;
//     data['have_image'] = haveImage;
//     data['url_icon'] = urlIcon;
//     data['items'] = items;
//     if (menus != String) {
//       data['menus'] = menus!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Menu {
//   String? merchantId;
//   String? itemId;
//   String? itemToken;
//   String? parentId;
//   String? catId;
//   String? itemName;
//   String? itemAlternativeName;
//   String? itemDescription;
//   String? itemShortDescription;
//   String? urlImage;
//   bool? haveImage;
//   bool? cookingRefRequired;

//   Menu(
//       {this.merchantId,
//       this.itemId,
//       this.itemToken,
//       this.parentId,
//       this.catId,
//       this.itemName,
//       this.itemAlternativeName,
//       this.itemDescription,
//       this.itemShortDescription,
//       this.urlImage,
//       this.haveImage,
//       this.cookingRefRequired});

//    Menu.fromJson(Map<String, dynamic> json) {
//     merchantId = json['merchant_id'];
//     itemId = json['item_id'];
//     itemToken = json['item_token'];
//     parentId = json['parent_id'];
//     catId = json['cat_id'];
//     itemName = json['item_name'];
//     itemAlternativeName = json['item_alternative_name'];
//     itemDescription = json['item_description'];
//     itemShortDescription = json['item_short_description'];
//     urlImage = json['url_image'];
//     haveImage = json['have_image'];
//     cookingRefRequired = json['cooking_ref_required'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['merchant_id'] = merchantId;
//     data['item_id'] = itemId;
//     data['item_token'] = itemToken;
//     data['parent_id'] = parentId;
//     data['cat_id'] = catId;
//     data['item_name'] = itemName;
//     data['item_alternative_name'] = itemAlternativeName;
//     data['item_description'] = itemDescription;
//     data['item_short_description'] = itemShortDescription;
//     data['url_image'] = urlImage;
//     data['have_image'] = haveImage;
//     data['cooking_ref_required'] = cookingRefRequired;
//     return data;
//   }
// }





class Details {
	List<MenuModel>? menus;
	List<String>? itemsNotAvailable;
	List<String>? categoryNotAvailable;
	List<PizzaPortionTypes>? pizzaPortionTypes;
	List<PizzaPortionSections>? pizzaPortionSections;
	bool? showAddonImage;
	bool? showPizzaPrice;

	Details({this.menus, this.itemsNotAvailable, this.categoryNotAvailable, this.pizzaPortionTypes, this.pizzaPortionSections, this.showAddonImage, this.showPizzaPrice});

	Details.fromJson(Map<String, dynamic> json) {
		if (json['menus'] != String) {
			menus = [];
			json['menus'].forEach((v) { menus!.add(MenuModel.fromJson(v)); });
		}
		if (json['items_not_available'] != String) {
			itemsNotAvailable = [];
			json['items_not_available'].forEach((v) { itemsNotAvailable!.add(v); });
		}
		if (json['category_not_available'] != String) {
			categoryNotAvailable = [];
			json['category_not_available'].forEach((v) { categoryNotAvailable!.add(v); });
		}
		if (json['pizza_portion_types'] != String) {
			pizzaPortionTypes = [];
			json['pizza_portion_types'].forEach((v) { pizzaPortionTypes!.add(PizzaPortionTypes.fromJson(v)); });
		}
		if (json['pizza_portion_sections'] != String) {
			pizzaPortionSections =[];
			json['pizza_portion_sections'].forEach((v) { pizzaPortionSections!.add(PizzaPortionSections.fromJson(v)); });
		}
		showAddonImage = json['show_addon_image'];
		showPizzaPrice = json['show_pizza_price'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		if (menus != null) {
      data['menus'] = menus!.map((v) => v.toJson()).toList();
    }
		if (itemsNotAvailable != null) {
      data['items_not_available'] = itemsNotAvailable!.map((v) => v).toList();
    }
		if (categoryNotAvailable != null) {
      data['category_not_available'] = categoryNotAvailable!.map((v) => v).toList();
    }
		if (pizzaPortionTypes != null) {
      data['pizza_portion_types'] = pizzaPortionTypes!.map((v) => v.toJson()).toList();
    }
		if (pizzaPortionSections != null) {
      data['pizza_portion_sections'] = pizzaPortionSections!.map((v) => v.toJson()).toList();
    }
		data['show_addon_image'] = showAddonImage;
		data['show_pizza_price'] = showPizzaPrice;
		return data;
	}
}

class MenuModel {
	String? catId;
	String? categoryUiid;
	String? categoryName;
	String? categoryDescription;
	String? urlImage;
	bool? haveImage;
	String? urlIcon;
	List<String>? items;
	List<Menus>? menus;

	MenuModel({this.catId, this.categoryUiid, this.categoryName, this.categoryDescription, this.urlImage, this.haveImage, this.urlIcon, this.items, this.menus});

	MenuModel.fromJson(Map<String, dynamic> json) {
		catId = json['cat_id'];
		categoryUiid = json['category_uiid'];
		categoryName = json['category_name'];
		categoryDescription = json['category_description'];
		urlImage = json['url_image'];
		haveImage = json['have_image'];
		urlIcon = json['url_icon'];
		items = json['items'].cast<String>();
		if (json['menus'] != String) {
			menus = [];
			json['menus'].forEach((v) { menus!.add(Menus.fromJson(v)); });
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

class Menus {
	String?merchantId;
	String?itemId;
	String?itemToken;
	String?parentId;
	String?catId;
	String?itemName;
	String?itemAlternativeName;
	String?itemDescription;
	String?itemShortDescription;
	String?urlImage;
	bool?haveImage;
	bool?cookingRefRequired;
	bool?ingredientsPreselected;
	bool?notForSale;
	List<Price>? price;
	List<SubItems>? subItems;
	bool? haveSubItems;
	int? sequence;
	bool? isPizzaItem;
	String?nextOpeningTime;
	List<TagAlongItems>? tagAlongItems;


	Menus({this.merchantId, this.itemId, this.itemToken, this.parentId, this.catId, this.itemName, this.itemAlternativeName, this.itemDescription, this.itemShortDescription, this.urlImage, this.haveImage, this.cookingRefRequired, this.ingredientsPreselected, this.notForSale, this.price,  this.subItems, this.haveSubItems, this.sequence, this.isPizzaItem, this.nextOpeningTime, this.tagAlongItems});

	Menus.fromJson(Map<String, dynamic> json) {
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
		if (json['price'] != String) {
			price = [];
			json['price'].forEach((v) { price!.add(Price.fromJson(v)); });
		}

		if (json['sub_items'] != String) {
			subItems =[];
			json['sub_items'].forEach((v) { subItems!.add(SubItems.fromJson(v)); });
		}
		haveSubItems = json['have_sub_items'];
		sequence = json['sequence'];
		isPizzaItem = json['is_pizza_item'];
		nextOpeningTime = json['next_opening_time'];
		if (json['tag_along_items'] != String) {
			tagAlongItems = [];
			json['tag_along_items'].forEach((v) { tagAlongItems!.add(TagAlongItems.fromJson(v)); });
		}
	
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
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
		if (price != null) {
      data['price'] = price!.map((v) => v.toJson()).toList();
    }

		if (subItems != null) {
      data['sub_items'] = subItems!.map((v) => v.toJson()).toList();
    }
		data['have_sub_items'] = haveSubItems;
		data['sequence'] = sequence;
		data['is_pizza_item'] = isPizzaItem;
		data['next_opening_time'] = nextOpeningTime;
		if (tagAlongItems != null) {
      data['tag_along_items'] = tagAlongItems!.map((v) => v.toJson()).toList();
    }
	
		return data;
	}
}

class Price {
	// int? key;
	String?sizeUuid;
	String?itemSizeId;
	// int? price;
	String?sizeName;
	// int? discount;
	String?discountType;
	// int? priceAfterDiscount;
	String?prettyPrice;
	String?prettyPriceAfterDiscount;
	// bool?pointsEnabled;
	// int? earningPoints;
	// String?earningPointsLabel;
	String?itemId;
	String?available;
	// List<Addons>? addons;

  Price(
      {
        // this.key,
      this.sizeUuid,
      this.itemSizeId,
      // this.price,
      this.sizeName,
      // this.discount,
      this.discountType,
      // this.priceAfterDiscount,
      this.prettyPrice,
      this.prettyPriceAfterDiscount,
      // this.pointsEnabled,
      // this.earningPoints,
      // this.earningPointsLabel,
      this.itemId,
      this.available,
      // this.addons
      });

	Price.fromJson(Map<String, dynamic> json) {
		// key = json['key'];
		sizeUuid = json['size_uuid'];
		itemSizeId = json['item_size_id'];
		// price = json['price'];
		sizeName = json['size_name'];
		// discount = json['discount'];
		discountType = json['discount_type'];
		// priceAfterDiscount = json['price_after_discount'];
		prettyPrice = json['pretty_price'];
		prettyPriceAfterDiscount = json['pretty_price_after_discount'];
		// pointsEnabled = json['points_enabled'];
		// earningPoints = json['earning_points'];
		// earningPointsLabel = json['earning_points_label'];
		itemId = json['item_id'];
		available = json['available'];
		// if (json['addons'] != String) {
		// 	addons = [];
		// 	json['addons'].forEach((v) { addons!.add(Addons.fromJson(v)); });
		// }
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		// data['key'] = key;
		data['size_uuid'] = sizeUuid;
		data['item_size_id'] = itemSizeId;
		// data['price'] = price;
		data['size_name'] = sizeName;
		// data['discount'] = discount;
		data['discount_type'] = discountType;
		// data['price_after_discount'] = priceAfterDiscount;
		data['pretty_price'] = prettyPrice;
		data['pretty_price_after_discount'] = prettyPriceAfterDiscount;
		// data['points_enabled'] = pointsEnabled;
		// data['earning_points'] = earningPoints;
		// data['earning_points_label'] = earningPointsLabel;
		data['item_id'] = itemId;
		data['available'] = available;
		// if (addons != null) {
    //   data['addons'] = addons!.map((v) => v.toJson()).toList();
    // }
		return data;
	}
}

class Addons {
	String?subcatId;
	String?subcategoryName;
	String?subcategoryDescription;
	String?multiOption;
	// int? multiOptionMin;
	// int? multiOptionValue;
	String?requireAddon;
	String?preSelected;
	List<String>? subItems;
	bool?isPizzaItem;
	bool?isPizzaCrust;
	bool?isPizzaSauce;
	bool?isPizzaTopping;
	// int? hideSubcategoryName;
	// int? sequence;
	List<AddonItems>? addonItems;

  Addons(
      {this.subcatId,
      this.subcategoryName,
      this.subcategoryDescription,
      this.multiOption,
      // this.multiOptionMin,
      // this.multiOptionValue,
      this.requireAddon,
      this.preSelected,
      this.subItems,
      this.isPizzaItem,
      this.isPizzaCrust,
      this.isPizzaSauce,
      this.isPizzaTopping,
      // this.hideSubcategoryName,
      // this.sequence,
      this.addonItems});

  Addons.fromJson(Map<String, dynamic> json) {
		subcatId = json['subcat_id'];
		subcategoryName = json['subcategory_name'];
		subcategoryDescription = json['subcategory_description'];
		multiOption = json['multi_option'];
		// multiOptionMin = json['multi_option_min'];
		// multiOptionValue = json['multi_option_value'];
		requireAddon = json['require_addon'];
		preSelected = json['pre_selected'];
		subItems = json['sub_items'].cast<String>();
		isPizzaItem = json['is_pizza_item'];
		isPizzaCrust = json['is_pizza_crust'];
		isPizzaSauce = json['is_pizza_sauce'];
		isPizzaTopping = json['is_pizza_topping'];
		// hideSubcategoryName = json['hide_subcategory_name'];
		// sequence = json['sequence'];
		if (json['addon_items'] != String) {
			addonItems = [];
			json['addon_items'].forEach((v) { addonItems!.add(AddonItems.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['subcat_id'] = subcatId;
		data['subcategory_name'] = subcategoryName;
		data['subcategory_description'] = subcategoryDescription;
		data['multi_option'] = multiOption;
		// data['multi_option_min'] = multiOptionMin;
		// data['multi_option_value'] = multiOptionValue;
		data['require_addon'] = requireAddon;
		data['pre_selected'] = preSelected;
		data['sub_items'] = subItems;
		data['is_pizza_item'] = isPizzaItem;
		data['is_pizza_crust'] = isPizzaCrust;
		data['is_pizza_sauce'] = isPizzaSauce;
		data['is_pizza_topping'] = isPizzaTopping;
		// data['hide_subcategory_name'] = hideSubcategoryName;
		// data['sequence'] = sequence;
		if (addonItems != null) {
      data['addon_items'] = addonItems!.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class AddonItems {
	int? subItemId;
	String?subItemName;
	String?itemDescription;
	// int? price;
	String?prettyPrice;
	String?urlImage;
	bool?haveImage;
	bool?isPizzaItem;
	bool?isPizzaCrust;
	bool?isPizzaSauce;
	bool?isPizzaTopping;
	String?pizzaSizeName;
	String?pizzaFactor;
	// int? hideSubcategoryName;
	// int? sequence;
	String?commonName;
	// int? noActionPrice;
	String?noActionPricePretty;
	// int? extraActionPrice;
	String?extraActionPricePretty;
	// int? liteActionPrice;
	String?liteActionPricePretty;
	// int? sideActionPrice;
	String?sideActionPricePretty;
	// int? doubleActionPrice;
	String?doubleActionPricePretty;
	// int? tripleActionPrice;
	String?tripleActionPricePretty;
	// int? halfActionPrice;
	String?halfActionPricePretty;
	// int? exchangeActionPrice;
	String?exchangeActionPricePretty;
	// int? onlyActionPrice;
	String?onlyActionPricePretty;
	List<SubPrices>? subPrices;

  AddonItems(
      {this.subItemId,
      this.subItemName,
      this.itemDescription,
      // this.price,
      this.prettyPrice,
      this.urlImage,
      this.haveImage,
      this.isPizzaItem,
      this.isPizzaCrust,
      this.isPizzaSauce,
      this.isPizzaTopping,
      this.pizzaSizeName,
      this.pizzaFactor,
      // this.hideSubcategoryName,
      // this.sequence,
      this.commonName,
      // this.noActionPrice,
      this.noActionPricePretty,
      // this.extraActionPrice,
      this.extraActionPricePretty,
      // this.liteActionPrice,
      this.liteActionPricePretty,
      // this.sideActionPrice,
      this.sideActionPricePretty,
      // this.doubleActionPrice,
      this.doubleActionPricePretty,
      // this.tripleActionPrice,
      this.tripleActionPricePretty,
      // this.halfActionPrice,
      this.halfActionPricePretty,
      // this.exchangeActionPrice,
      this.exchangeActionPricePretty,
      // this.onlyActionPrice,
      this.onlyActionPricePretty,
      this.subPrices});

	AddonItems.fromJson(Map<String, dynamic> json) {
		subItemId = json['sub_item_id'];
		subItemName = json['sub_item_name'];
		itemDescription = json['item_description'];
		// price = json['price'];
		prettyPrice = json['pretty_price'];
		urlImage = json['url_image'];
		haveImage = json['have_image'];
		isPizzaItem = json['is_pizza_item'];
		isPizzaCrust = json['is_pizza_crust'];
		isPizzaSauce = json['is_pizza_sauce'];
		isPizzaTopping = json['is_pizza_topping'];
		pizzaSizeName = json['pizza_size_name'];
		pizzaFactor = json['pizza_factor'];
		// hideSubcategoryName = json['hide_subcategory_name'];
		// sequence = json['sequence'];
		commonName = json['common_name'];
		// noActionPrice = json['no_action_price'];
		noActionPricePretty = json['no_action_price_pretty'];
		// extraActionPrice = json['extra_action_price'];
		extraActionPricePretty = json['extra_action_price_pretty'];
		// liteActionPrice = json['lite_action_price'];
		liteActionPricePretty = json['lite_action_price_pretty'];
		// sideActionPrice = json['side_action_price'];
		sideActionPricePretty = json['side_action_price_pretty'];
		// doubleActionPrice = json['double_action_price'];
		doubleActionPricePretty = json['double_action_price_pretty'];
		// tripleActionPrice = json['triple_action_price'];
		tripleActionPricePretty = json['triple_action_price_pretty'];
		// halfActionPrice = json['half_action_price'];
		halfActionPricePretty = json['half_action_price_pretty'];
		// exchangeActionPrice = json['exchange_action_price'];
		exchangeActionPricePretty = json['exchange_action_price_pretty'];
		// onlyActionPrice = json['only_action_price'];
		onlyActionPricePretty = json['only_action_price_pretty'];
		if (json['sub_prices'] != String) {
			subPrices = [];
			json['sub_prices'].forEach((v) { subPrices!.add(SubPrices.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['sub_item_id'] = subItemId;
		data['sub_item_name'] = subItemName;
		data['item_description'] = itemDescription;
		// data['price'] = price;
		data['pretty_price'] = prettyPrice;
		data['url_image'] = urlImage;
		data['have_image'] = haveImage;
		data['is_pizza_item'] = isPizzaItem;
		data['is_pizza_crust'] = isPizzaCrust;
		data['is_pizza_sauce'] = isPizzaSauce;
		data['is_pizza_topping'] = isPizzaTopping;
		data['pizza_size_name'] = pizzaSizeName;
		data['pizza_factor'] = pizzaFactor;
		// data['hide_subcategory_name'] = hideSubcategoryName;
		// data['sequence'] = sequence;
		data['common_name'] = commonName;
		// data['no_action_price'] = noActionPrice;
		data['no_action_price_pretty'] = noActionPricePretty;
		// data['extra_action_price'] = extraActionPrice;
		data['extra_action_price_pretty'] = extraActionPricePretty;
		// data['lite_action_price'] = liteActionPrice;
		data['lite_action_price_pretty'] = liteActionPricePretty;
		// data['side_action_price'] = sideActionPrice;
		data['side_action_price_pretty'] = sideActionPricePretty;
		// data['double_action_price'] = doubleActionPrice;
		data['double_action_price_pretty'] = doubleActionPricePretty;
		// data['triple_action_price'] = tripleActionPrice;
		data['triple_action_price_pretty'] = tripleActionPricePretty;
		// data['half_action_price'] = halfActionPrice;
		data['half_action_price_pretty'] = halfActionPricePretty;
		// data['exchange_action_price'] = exchangeActionPrice;
		data['exchange_action_price_pretty'] = exchangeActionPricePretty;
		// data['only_action_price'] = onlyActionPrice;
		data['only_action_price_pretty'] = onlyActionPricePretty;
		if (subPrices != null) {
      data['sub_prices'] = subPrices!.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class SubPrices {
	String?name;
	num? price;
	String?prettyPrice;
	String?type;

  SubPrices({this.name
   ,this.price
   , this.prettyPrice, this.type});

	SubPrices.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		price = json['price'];
		prettyPrice = json['pretty_price'];
		type = json['type'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['name'] = name;
		// data['price'] = price;
		data['pretty_price'] = prettyPrice;
		data['type'] = type;
		return data;
	}
}


class SubItems {
	String?merchantId;
	String?itemId;
	String?itemToken;
	String?parentId;
	String?catId;
	String?itemName;
	String?itemAlternativeName;
	String?itemDescription;
	String?itemShortDescription;
	String?urlImage;
	bool?haveImage;
	bool?cookingRefRequired;
	bool?ingredientsPreselected;
	bool?notForSale;
	List<Price>? price;
	List<String>? subItems;
	bool?haveSubItems;
	// int? sequence;
	bool?isPizzaItem;
	String?nextOpeningTime;
	List<String>? tagAlongItems;

	SubItems({this.merchantId, this.itemId, this.itemToken, this.parentId, this.catId, this.itemName, this.itemAlternativeName, this.itemDescription, this.itemShortDescription, this.urlImage, this.haveImage, this.cookingRefRequired, this.ingredientsPreselected, this.notForSale, this.price, this.subItems, this.haveSubItems
  // , this.sequence
  , this.isPizzaItem, this.nextOpeningTime, this.tagAlongItems});

	SubItems.fromJson(Map<String, dynamic> json) {
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
		if (json['price'] != String) {
			price = [];
			json['price'].forEach((v) { price!.add(Price.fromJson(v)); });
		}

		if (json['sub_items'] != String) {
			subItems = [];
			json['sub_items'].forEach((v) { subItems!.add(v); });
		}
		haveSubItems = json['have_sub_items'];
		// sequence = json['sequence'];
		isPizzaItem = json['is_pizza_item'];
		nextOpeningTime = json['next_opening_time'];
		if (json['tag_along_items'] != String) {
			tagAlongItems =[];
			json['tag_along_items'].forEach((v) { tagAlongItems!.add(v); });
		}

	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
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
		if (price != null) {
      data['price'] = price!.map((v) => v.toJson()).toList();
    }

		if (subItems != null) {
      data['sub_items'] = subItems!.map((v) => v).toList();
    }
		data['have_sub_items'] = haveSubItems;
		// data['sequence'] = sequence;
		data['is_pizza_item'] = isPizzaItem;
		data['next_opening_time'] = nextOpeningTime;
		if (tagAlongItems != null) {
      data['tag_along_items'] = tagAlongItems!.map((v) => v).toList();
    }

		return data;
	}
}




class SubModifiers {
	int? subItemId;
	String?subItemName;
	String?itemDescription;
	int? price;
	String?prettyPrice;
	String?urlImage;
	bool?haveImage;
	bool?isPizzaItem;
	bool?isPizzaCrust;
	bool?isPizzaSauce;
	bool?isPizzaTopping;
	String?pizzaSizeName;
	String?pizzaFactor;
	int? hideSubcategoryName;
	int? sequence;
	String?commonName;
	List<SubPrices>? subPrices;
	bool?checked;
	String?name;

	SubModifiers({this.subItemId, this.subItemName, this.itemDescription, this.price, this.prettyPrice, this.urlImage, this.haveImage, this.isPizzaItem, this.isPizzaCrust, this.isPizzaSauce, this.isPizzaTopping, this.pizzaSizeName, this.pizzaFactor, this.hideSubcategoryName, this.sequence, this.commonName, this.subPrices, this.checked, this.name});

	SubModifiers.fromJson(Map<String, dynamic> json) {
		subItemId = json['sub_item_id'];
		subItemName = json['sub_item_name'];
		itemDescription = json['item_description'];
		price = json['price'];
		prettyPrice = json['pretty_price'];
		urlImage = json['url_image'];
		haveImage = json['have_image'];
		isPizzaItem = json['is_pizza_item'];
		isPizzaCrust = json['is_pizza_crust'];
		isPizzaSauce = json['is_pizza_sauce'];
		isPizzaTopping = json['is_pizza_topping'];
		pizzaSizeName = json['pizza_size_name'];
		pizzaFactor = json['pizza_factor'];
		hideSubcategoryName = json['hide_subcategory_name'];
		sequence = json['sequence'];
		commonName = json['common_name'];
		if (json['sub_prices'] != String) {
			subPrices = [];
			json['sub_prices'].forEach((v) { subPrices!.add(SubPrices.fromJson(v)); });
		}
		checked = json['checked'];
		name = json['name'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['sub_item_id'] = subItemId;
		data['sub_item_name'] = subItemName;
		data['item_description'] = itemDescription;
		data['price'] = price;
		data['pretty_price'] = prettyPrice;
		data['url_image'] = urlImage;
		data['have_image'] = haveImage;
		data['is_pizza_item'] = isPizzaItem;
		data['is_pizza_crust'] = isPizzaCrust;
		data['is_pizza_sauce'] = isPizzaSauce;
		data['is_pizza_topping'] = isPizzaTopping;
		data['pizza_size_name'] = pizzaSizeName;
		data['pizza_factor'] = pizzaFactor;
		data['hide_subcategory_name'] = hideSubcategoryName;
		data['sequence'] = sequence;
		data['common_name'] = commonName;
		if (subPrices != null) {
      data['sub_prices'] = subPrices!.map((v) => v.toJson()).toList();
    }
		data['checked'] = checked;
		data['name'] = name;
		return data;
	}
}


// class MetaDetails {


// 	MetaDetails();

// 	MetaDetails.fromJson(Map<String, dynamic> json) {
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = Map<String, dynamic>();
// 		return data;
// 	}
// }

class TagAlongItems {
	String?merchantId;
	String?itemId;
	String?itemToken;
	String?parentId;
	String?catId;
	String?itemName;
	String?itemAlternativeName;
	String?itemDescription;
	String?itemShortDescription;
	String?urlImage;
	bool?haveImage;
	bool?cookingRefRequired;
	bool?ingredientsPreselected;
	bool?notForSale;
	List<Price>? price;
	List<String>? subItems;
	bool?haveSubItems;
	int? sequence;
	bool?isPizzaItem;
	String?nextOpeningTime;
	List<String>? tagAlongItems;
	String?isZeroPrice;

	TagAlongItems({this.merchantId, this.itemId, this.itemToken, this.parentId, this.catId, this.itemName, this.itemAlternativeName, this.itemDescription, this.itemShortDescription, this.urlImage, this.haveImage, this.cookingRefRequired, this.ingredientsPreselected, this.notForSale, this.price,  this.subItems, this.haveSubItems, this.sequence, this.isPizzaItem, this.nextOpeningTime, this.tagAlongItems, this.isZeroPrice});

	TagAlongItems.fromJson(Map<String, dynamic> json) {
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
		if (json['price'] != String) {
			price = [];
			json['price'].forEach((v) { price!.add(Price.fromJson(v)); });
		}
		if (json['sub_items'] != String) {
			subItems = [];
			json['sub_items'].forEach((v) { subItems!.add(v); });
		}
		haveSubItems = json['have_sub_items'];
		sequence = json['sequence'];
		isPizzaItem = json['is_pizza_item'];
		nextOpeningTime = json['next_opening_time'];
		if (json['tag_along_items'] != String) {
			tagAlongItems = [];
			json['tag_along_items'].forEach((v) { tagAlongItems!.add(v); });
		}
		isZeroPrice = json['is_zero_price'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
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
		if (price != null) {
      data['price'] = price!.map((v) => v.toJson()).toList();
    }

		if (subItems != null) {
      data['sub_items'] = subItems!.map((v) => v).toList();
    }
		data['have_sub_items'] = haveSubItems;
		data['sequence'] = sequence;
		data['is_pizza_item'] = isPizzaItem;
		data['next_opening_time'] = nextOpeningTime;
		if (tagAlongItems != null) {
      data['tag_along_items'] = tagAlongItems!.map((v) => v).toList();
    }
		data['is_zero_price'] = isZeroPrice;
		return data;
	}
}



class PizzaPortionTypes {
	String?id;
	String?status;
	String?name;
	String?value;

	PizzaPortionTypes({this.id, this.status, this.name, this.value});

	PizzaPortionTypes.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		status = json['status'];
		name = json['name'];
		value = json['value'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['id'] = id;
		data['status'] = status;
		data['name'] = name;
		data['value'] = value;
		return data;
	}
}

class PizzaPortionSections {
	String?id;
	String?name;
	String?value;
	String?type;

	PizzaPortionSections({this.id, this.name, this.value, this.type});

	PizzaPortionSections.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
		value = json['value'];
		type = json['type'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['id'] = id;
		data['name'] = name;
		data['value'] = value;
		data['type'] = type;
		return data;
	}
}

