class ProviderModel {
  String? id;
  String? merchantId;
  String? providerId;
  String? providerStoreId;
  String? status;
  String? accountType;
  String? onlineStatus;
  int? pauseDuration;
  String? pauseReason;
  String? deletedAt;
  String? createdAt;
  String? integrationAccountId;

  ProviderModel(
      {this.id,
      this.merchantId,
      this.providerId,
      this.providerStoreId,
      this.status,
      this.accountType,
      this.onlineStatus,
      this.pauseDuration,
      this.pauseReason,
      this.deletedAt,
      this.createdAt,
      this.integrationAccountId});

  ProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    providerId = json['provider_id'];
    providerStoreId = json['provider_store_id'];
    status = json['status'];
    accountType = json['account_type'];
    onlineStatus = json['online_status'];
    pauseDuration = json['pause_duration'];
    pauseReason = json['pause_reason'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    integrationAccountId = json['integration_account_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchant_id'] = merchantId;
    data['provider_id'] = providerId;
    data['provider_store_id'] = providerStoreId;
    data['status'] = status;
    data['account_type'] = accountType;
    data['online_status'] = onlineStatus;
    data['pause_duration'] = pauseDuration;
    data['pause_reason'] = pauseReason;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['integration_account_id'] = integrationAccountId;
    return data;
  }
}
