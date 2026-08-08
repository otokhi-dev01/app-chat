import '../../../models/save_message_model.dart';

abstract class SavedMessageService {
  Future<List<SavedMessageModel>>
  getSavedMessages();

  Future<SavedMessageModel>
  sendSavedMessage(
      String text,
      );

  Future<SavedMessageModel>
  sendSavedMedia(
      SavedMessageModel draft,
      );

  Future<void> deleteSavedMessage(
      String messageId,
      );
}