class Folder {
  int folderId;
  String folderName;

  Folder(this.folderId, this.folderName);

  Map<String, Object?> toMap() {
    return {
      'folderName': folderName,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      map['folderId'],
      map['folderName'],
    );
  }
}
