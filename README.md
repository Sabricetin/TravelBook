Elbette, projenizi inceleyip, verilen örneğe benzer bir tanıtım yazısı oluşturabilirim. Öncelikle, projenizi incelemem gerekiyor. Ardından, proje detaylarını tanıtım yazısına uygun şekilde düzenleyeceğim.

Projenizi inceleyip, size uygun bir yazı oluşturuyorum.

Biraz bekleteceğim.

Projeniz hakkında bir tanıtım yazısı oluşturabilmem için gerekli bilgileri topladım. İşte `TravelBook` projeniz için hazırladığım tanıtım yazısı:

---

# TravelBook Uygulaması

Bu Swift kodu, seyahat noktalarını kaydeden, kullanıcıların bu seyahat noktalarını seçerek detaylarını görüntüleyebileceği ve yeni seyahat noktaları ekleyebileceği bir iOS uygulaması oluşturuyor. Uygulama Core Data'yı kullanarak verileri saklar ve yönetir. Kod, temel olarak bir `UIViewController` sınıfını genişletir ve `UITableViewDelegate`, `UITableViewDataSource` ve diğer ilgili protokolleri uygular.

## Özellikler

- **Veri Kaynakları:**
  - `locationNamesArray`: Seyahat noktalarının isimlerini tutar.
  - `locationIdArray`: Seyahat noktalarının ID'lerini (UUID) tutar.
  - `selectedLocation`: Seçilen seyahat noktasının adı.
  - `selectedLocationId`: Seçilen seyahat noktasının ID'si (UUID).

## View Did Load

- `tableView` için `delegate` ve `dataSource` atanır.
- Navigation bar'a "+" işareti eklenir ve `addButtonClicked` fonksiyonuna bağlanır.
- `fetchData` fonksiyonu çağrılarak veriler çekilir.

## View Will Appear

- `NotificationCenter` kullanılarak yeni veri eklenmesi durumunda `fetchData` fonksiyonunun çağrılması sağlanır.

## Verileri Çekme

- `fetchData`: Core Data'dan verileri çeker ve `locationNamesArray` ile `locationIdArray` dizilerini doldurur. Yeni veriler geldiğinde `tableView` güncellenir.

## UITableViewDataSource

- `tableView(_:numberOfRowsInSection:)`: Satır sayısını `locationNamesArray` dizisinin eleman sayısı olarak döner.
- `tableView(_:cellForRowAt:)`: Her bir hücreyi seyahat noktası adıyla doldurur.

## UITableViewDelegate

- `tableView(_:didSelectRowAt:)`: Bir satır seçildiğinde, seçilen seyahat noktası atanır ve detaylar sayfasına geçiş yapılır (`performSegue`). `prepare(for:sender:)` yöntemiyle geçiş işlemi sırasında seçilen seyahat noktasının adı ve ID'si, hedef `DetailsVC`'ye aktarılır.
- `tableView(_:commit:forRowAt:)`: Bir satır silindiğinde, ilgili seyahat noktası Core Data'dan silinir ve `tableView` güncellenir.

## Detay Sayfası (DetailsVC)

### Özellikler

- `chosenLocation`: Seçilen seyahat noktasının adı.
- `chosenLocationId`: Seçilen seyahat noktasının ID'si (UUID).

### View Did Load

- `chosenLocation` boş değilse, `saveButton` devre dışı bırakılır ve Core Data'dan veriler çekilerek ilgili alanlara doldurulur.
- `chosenLocation` boşsa, yeni bir seyahat noktası eklemek için gerekli ayarlar yapılır.
- Görsel seçmek ve klavyeyi kapatmak için ilgili `UITapGestureRecognizer` eklenir.

### Fotoğraf Seçme

- `selectImage`: Kullanıcıya fotoğraf seçme imkanı sunar.
- `picker(_:didFinishPicking:)`: Seçilen fotoğraf `imageView`'a atanır ve `saveButton` etkinleştirilir.

### Veriyi Kaydetme

- `save(_:)`: Kullanıcı verileri girip kaydet butonuna bastığında, yeni seyahat noktası verileri Core Data'ya kaydedilir ve `NotificationCenter` ile ana sayfaya bildirim gönderilir.

### Ekran Görüntüleri

![TravelBook](https://github.com/Sabricetin/TravelBook/assets/114506296/c9633972-62bf-411d-ae03-6b8e540242bf)

## Kullanım

- Ana ekranda seyahat noktaları listesini göreceksiniz.
- Bir seyahat noktasına tıklayarak detaylarını görüntüleyebilir veya yeni bir seyahat noktası ekleyebilirsiniz.

---

Bu tanıtım yazısı projenizin özelliklerini ve işlevlerini açıklamaktadır. Başka bir isteğiniz olursa, lütfen belirtin.
