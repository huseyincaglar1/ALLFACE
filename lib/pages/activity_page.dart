import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoaiemo/util/my_background_img.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../util/my_botton.dart';

class ActivityPage extends StatelessWidget {
  final String suggestion;
  final String mood;

  const ActivityPage({super.key, required this.suggestion, required this.mood});

  Future<void> _approveActivity(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('ApprovedActivities');

      // Check if the activity already exists
      final querySnapshot = await userDoc
          .where('activityName', isEqualTo: suggestion)
          .where('mood', isEqualTo: mood)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Activity does not exist, add a new entry
        await userDoc.add({
          'activityName': suggestion,
          'mood': mood,
          'approvalDate': DateTime.now().toIso8601String(),
          'count': 1, // Initial count
        });
      } else {
        // Activity exists, update the count
        final docId = querySnapshot.docs.single.id;
        final docRef = userDoc.doc(docId);

        await docRef.update({
          'count': FieldValue.increment(1),
          'lastApprovalDate': DateTime.now().toIso8601String(),
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity approved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Redirect to ApprovedActivitiesPage
      await Future.delayed(const Duration(
          seconds: 2)); // Optional delay to let the snackbar display
    } catch (e) {
      print('Error saving approved activity: $e');
    }
  }

  String getActivitySuggestion(String activity) {
    switch (activity) {
    case 'Yazma Terapisi':
        return 'Yazma terapisi, duygularınızı ifade etmenin ve zihinsel rahatlama sağlamanın harika bir yoludur.';
    case 'Meditasyon Yapmak':
        return 'Meditasyon yapmak, zihninizi sakinleştirir ve stres seviyenizi azaltır.';
    case 'Arkadaşlarla Buluşmak':
        return 'Arkadaşlarla bir araya gelmek, sosyal bağlarınızı güçlendirir ve keyifli anlar yaşamanızı sağlar.';
    case 'Konsere Gitmek':
        return 'Canlı müzik dinlemek, enerjinizi artırır ve eğlenceli bir deneyim sunar.';
    case 'Kitap Okumak':
        return 'Kitap okumak, yeni dünyalara açılan kapılar sunar ve hayal gücünüzü geliştirir.';
    case 'Müzik Dinlemek':
        return 'Sevdiğiniz müzikleri dinlemek ruh halinizi iyileştirir ve stresi azaltır.';
    case 'Yalnız Kalmak':
        return 'Yalnız kalmak, kendinizle baş başa kalmanın ve içsel düşüncelerinizi dinlendirmenin en iyi yollarından biridir.';
    case 'Yürüyüş Yapmak':
        return 'Yürüyüş yapmak, hem fiziksel sağlığınıza katkı sağlar hem de zihninizi rahatlatır.';
    case 'Aile İle Vakit Geçirmek':
        return 'Ailenizle vakit geçirmek, güçlü bağlar kurmanızı ve birlikte güzel anılar yaratmanızı sağlar.';
    case 'Arkadaşlarla Sohbet Etmek':
        return 'Arkadaşlarınızla sohbet etmek, duygusal destek sağlar ve ruh halinizi iyileştirir.';
    case 'Yoga Yapmak':
        return 'Yoga, bedensel esnekliğinizi artırır ve zihinsel rahatlama sağlar.';
    case 'Bahçeyle İlgilenmek':
        return 'Bahçeyle ilgilenmek, doğayla bağlantınızı güçlendirir ve huzur bulmanızı sağlar.';
    case 'Dinlenmek':
        return 'Dinlenmek, enerjinizi toparlamak ve zihinsel sağlığınızı korumak için gereklidir.';
    case 'Sergi Gezmek':
        return 'Sanat sergilerini gezmek, yaratıcılığınızı besler ve yeni ilham kaynakları sunar.';
    case 'El İşi Yapmak':
        return 'El işi yapmak, yaratıcılığınızı ifade etmenin ve keyifli zaman geçirmenin harika bir yoludur.';
    case 'Film İzlemek':
        return 'İyi bir film izlemek, eğlenceli bir kaçış sağlar ve farklı hikayelerle tanışmanızı sağlar.';
    case 'Bilgisayar Oyunu Oynamak':
        return 'Bilgisayar oyunları, eğlenceli bir aktivite sunar ve stresi azaltmaya yardımcı olabilir.';
    case 'İşine Odaklanmak':
        return 'İşinize odaklanmak, hedeflerinize ulaşmanıza yardımcı olur ve verimliliğinizi artırır.';
    case 'Yemek Yapmak':
        return 'Sevdiğiniz yemekleri yapmak, hem eğlenceli hem de tatmin edici bir aktivitedir.';
    case 'Piknik Yapmak':
        return 'Açık havada piknik yapmak, doğayla iç içe olmanın keyfini çıkarır ve arkadaşlarınızla güzel anlar geçirmenizi sağlar.';
    case 'Resim Çizmek':
        return 'Resim yapmak, duygularınızı ifade etmenin yaratıcı bir yoludur.';
    case 'Spor Yapmak':
        return 'Spor yapmak, sağlığınızı korumanız ve stresi azaltmanız için önemlidir.';
    case 'Sinemaya Gitmek':
        return 'Sinemada film izlemek, eğlenceli bir deneyim sunar ve arkadaşlarınızla keyifli vakit geçirmenizi sağlar.';
    case 'Kütüphaneye Gitmek':
        return 'Kütüphaneler, bilgi edinmenin ve sessiz bir ortamda çalışmanın mükemmel yerleridir.';
    case 'Podcast Dinlemek':
        return 'Farklı konularda podcast dinlemek, yeni bilgiler edinmenizi ve farklı bakış açıları kazanmanızı sağlar.';
    case 'Yeni Bir Hobi Edinmek':
        return 'Yeni bir hobi edinmek, yaşamınıza renk katar ve yeni beceriler geliştirmenizi sağlar.';
    case 'Zihin Egzersizleri':
        return 'Zihin egzersizleri yapmak, zihinsel sağlığınızı korur ve düşünme yeteneğinizi geliştirir.';
    case 'Bisiklet Sürmek':
        return 'Bisiklet sürmek, hem eğlenceli bir aktivitedir hem de fiziksel sağlığınıza katkı sağlar.';
    case 'Kamp Yapmak':
        return 'Doğayla baş başa kalmanın en güzel yollarından biri kamp yapmaktır. Arkadaşlarınla birlikte doğada vakit geçirerek unutulmaz anılar biriktirebilirsin.';
    case 'Sosyal Medya İçerik Üretimi':
        return 'Sosyal medya içerikleri üreterek yaratıcılığınızı ifade edebilir ve takipçilerinizle etkileşimde bulunabilirsiniz.';
    case 'Arkadaşlarla Medya ve Eğlence Konulu Bir Etkinliğe Katılmak':
        return 'Eğlenceli etkinlikler, arkadaşlarınızla vakit geçirmenin ve sosyal bağlarınızı güçlendirmenin harika bir yoludur.';
    case 'Bir Finans Seminerine Katılmak ve Bilgi Paylaşımında Bulunmak':
        return 'Finans seminerleri, bilgi edinmenizi ve finansal okuryazarlığınızı artırmanızı sağlar.';
    case 'Finans Üzerine Bir Kitap Okuyarak Kendini Geliştirmek':
        return 'Finansal okuryazarlığınızı artırmak için kitap okumak, önemli bilgiler edinmenizi sağlar.';
    case 'Hukuki Konularda Bir Panel Veya Seminere Katılmak':
        return 'Hukuki konular hakkında bilgi edinmek için panellere katılmak faydalı olabilir.';
    case 'Sağlık ve Wellness Etkinliklerine Katılmak':
        return 'Sağlık ve wellness etkinlikleri, fiziksel ve zihinsel sağlığınızı destekler.';
    case 'Hukuki Kitaplar Okuyarak Kendini Geliştirmek':
        return 'Hukuki konularda bilgi edinmek için kitap okumak, kendinizi geliştirmenize yardımcı olur.';
    case 'Yeni Bir Eser Oluşturmak':
        return 'Yaratıcılığınızı kullanarak yeni eserler oluşturmak, kendinizi ifade etmenin güzel bir yoludur.';
    case 'Sanat Etkinliklerine Katılmak':
        return 'Sanat etkinliklerine katılmak, yeni yeteneklerinizi keşfetmenizi sağlar.';
    case 'Doğada Yürüyüş Yaparak İlham Almak':
        return 'Doğada yürüyüş yapmak, zihinsel ferahlama sağlar ve ilham kaynağı olabilir.';
    case 'Sanat Yoluyla Duygu Dışavurumu Yapmak':
        return 'Sanat, duygularınızı ifade etmenin yaratıcı bir yoludur.';
    case 'Hata Ayıklamak':
        return 'Hatalarınızı analiz etmek, öğrenmenize ve gelişmenize yardımcı olur.';
    case 'Emekli Olmayı Düşünmek':
        return 'Emeklilik, yeni bir yaşam dönemi ve farklı deneyimler için fırsatlar sunar.';
    case 'Yeni Bir Proje Geliştirmek':
        return 'Yeni projeler üzerinde çalışmak, yaratıcılığınızı artırır ve hedeflerinize ulaşmanızı sağlar.';
    case 'Yeni Teknolojileri Keşfetmek':
        return 'Yeni teknolojileri keşfetmek, çağın gerekliliklerine ayak uydurmanıza yardımcı olur.';
    case 'Teknoloji Etkinliklerine Katılmak':
        return 'Teknoloji etkinlikleri, yeni gelişmeleri öğrenmenin ve ağ kurmanın harika bir yoludur.';
    case 'Online Topluluklara Katılmak':
        return 'Online topluluklar, meslektaşlarınızla etkileşimde bulunmanızı ve destek almanızı sağlar.';
    case 'Kodlama Olmayan Hobilerine Yönelmek':
        return 'Kodlama dışındaki hobiler, zihninizi dinlendirir ve yeni beceriler kazandırır.';
    case 'Arkadaşlarla Müzik Dinleme Etkinliği Düzenlemek':
        return 'Arkadaşlarınızla müzik dinlemek, sosyal etkileşimi artırır ve eğlenceli bir atmosfer yaratır.';
    case 'Müzik Festivallerine Katılmak':
        return 'Müzik festivalleri, canlı müziğin tadını çıkarmanız için harika bir fırsattır.';
    case 'Yeni Enstrüman Denemek':
        return 'Yeni bir enstrüman denemek, müzik yeteneklerinizi geliştirmenin eğlenceli bir yoludur.';
    case 'Enstrüman Çalmak':
        return 'Enstrüman çalmak, yaratıcılığınızı ifade etmenin ve eğlenceli vakit geçirmenin harika bir yoludur.';
    case 'Yetenek Geliştirme Atölyelerine Katılmak':
        return 'Yeni yetenekler kazanmak için atölyelere katılmak, kişisel gelişiminize katkı sağlar.';
    case 'Yeni İnsanlarla Tanışmak':
        return 'Yeni insanlarla tanışmak, sosyal çevrenizi genişletir ve farklı bakış açıları kazanmanızı sağlar.';
    case 'Eğitim Programlarına Katılmak':
        return 'Eğitim programlarına katılmak, bilgi ve becerilerinizi geliştirmeye yardımcı olur.';
    case 'Bilgi Paylaşımında Bulunmak':
        return 'Kendi bilgi ve deneyimlerinizi paylaşmak, başkalarına ilham verebilir.';
    case 'Bir Projeye Liderlik Yapmak':
        return 'Proje liderliği, liderlik becerilerinizi geliştirmenin ve takımları yönlendirmenin harika bir yoludur.';
    case 'Yaratıcı Düşünme Atölyelerine Katılmak':
        return 'Yaratıcılığınızı geliştirmek için atölyelere katılmak faydalıdır.';
    case 'Hayvanlarla Vakit Geçirmek':
        return 'Hayvanlarla vakit geçirmek, stres seviyenizi düşürür ve ruh halinizi iyileştirir.';
    case 'Hava Durumuna Göre Plan Yapmak':
        return 'Hava durumu, açık hava etkinliklerinizi planlamada etkili bir faktördür.';
    case 'Sanat Müzelerini Gezmek':
        return 'Sanat müzeleri, kültürel birikiminizi artırır ve sanatı yakından tanımanızı sağlar.';
    case 'Eğitici İçerikler İzlemek':
        return 'Eğitici içerikler izlemek, bilgi edinmenin ve yeni beceriler kazanmanın harika bir yoludur.';
    case 'Bilgi Yarışmalarına Katılmak':
        return 'Bilgi yarışmaları, bilgilerinizi test etmenin ve eğlenceli vakit geçirmenin bir yoludur.';
    case 'Bir Dil Öğrenmek':
        return 'Yeni bir dil öğrenmek, kültürel anlayışınızı artırır ve iletişim becerilerinizi geliştirir.';
    case 'Sosyal Sorumluluk Projelerine Katılmak':
        return 'Sosyal sorumluluk projelerine katılarak topluma katkıda bulunabilir ve yeni deneyimler kazanabilirsiniz.';
    case 'Düşünce Paylaşımında Bulunmak':
        return 'Düşüncelerinizi paylaşmak, fikir alışverişine katkıda bulunur ve sosyal etkileşimi artırır.';
    case 'Bir Kütüphane Veya Okul İçin Gönüllü Olmak':
        return 'Gönüllü olmak, topluma katkıda bulunmanın ve yeni insanlarla tanışmanın güzel bir yoludur.';
    case 'Geri Dönüşüm Projelerine Katılmak':
        return 'Geri dönüşüm projeleri, çevre bilincinizi artırır ve sürdürülebilir yaşama katkı sağlar.';
    case 'Farklı Kültürleri Tanımak':
        return 'Farklı kültürleri tanımak, perspektifinizi genişletir ve zengin bir deneyim sunar.';
    case 'İnovasyon Atölyelerine Katılmak':
        return 'İnovasyon atölyeleri, yeni fikirler geliştirmenize ve yaratıcılığınızı artırmanıza yardımcı olur.';
    case 'Çevre Temizliği Etkinliklerine Katılmak':
        return 'Çevre temizliği etkinliklerine katılmak, çevre bilincinizi artırır ve topluma katkıda bulunur.';
    case 'Yeni Bir Teknoloji Ürünü Denemek':
        return 'Yeni teknolojik ürünler denemek, teknoloji dünyasında güncel kalmanıza yardımcı olur.';
    case 'Zihin Oyunları Oynamak':
        return 'Zihin oyunları, zihinsel becerilerinizi geliştirmek için eğlenceli bir yoldur.';
    case 'Hobi Olarak Tarım Yapmak':
        return 'Tarım yapmak, doğayla iç içe olmanın ve sağlıklı gıdalar yetiştirmenin harika bir yoludur.';
    case 'Çizgi Roman Okumak':
        return 'Çizgi roman okumak, eğlenceli bir hikaye anlatım şeklidir ve farklı görsel deneyimler sunar.';
    case 'Çocuklara Öğretmek':
        return 'Çocuklara bir şeyler öğretmek, bilgi paylaşımında bulunmanın ve sosyal sorumluluk üstlenmenin güzel bir yoludur.';
    case 'Bir Takımda Oynamak':
        return 'Takım sporları oynamak, sosyal becerilerinizi geliştirmeye ve arkadaşlık bağlarınızı güçlendirmeye yardımcı olur.';
    case 'Bir Müzikal Yapmak':
        return 'Müzikal, hem eğlenceli hem de yaratıcı bir deneyim sunar.';
    case 'Bir Seramik Atölyesine Katılmak':
        return 'Seramik yapımı, yaratıcı bir ifade biçimi ve eğlenceli bir aktivitedir.';
    case 'Kendi Yemek Tarifi Geliştirmek':
        return 'Kendi tariflerinizi geliştirmek, mutfakta yaratıcılığınızı ifade etmenin harika bir yoludur.';
    case 'Edebiyat Atölyelerine Katılmak':
        return 'Edebiyat atölyeleri, yazma becerilerinizi geliştirmenize ve yeni teknikler öğrenmenize yardımcı olur.';
    case 'Bir Podcast Hazırlamak':
        return 'Podcast hazırlamak, kendi sesinizi duyurmanın ve bilgi paylaşımında bulunmanın harika bir yoludur.';
    case 'Doğa Yürüyüşü Yapmak':
        return 'Doğa yürüyüşü yapmak, hem fiziksel hem de zihinsel sağlığınıza katkı sağlar.';
    case 'Günlük Tutmak':
        return 'Günlük tutmak, düşüncelerinizi ifade etmenin ve kendinizi daha iyi anlamanın bir yoludur.';
    case 'Yeni Bir Dil Kursuna Katılmak':
        return 'Yeni bir dil kursu, yeni diller öğrenmenizi ve iletişim becerilerinizi geliştirmenizi sağlar.';
    case 'Sanat Projeleri Üretmek':
        return 'Sanat projeleri üretmek, yaratıcılığınızı ifade etmenin ve kendinizi geliştirmenin harika bir yoludur.';
    case 'Bir Şiir Yazmak':
        return 'Şiir yazmak, duygularınızı ifade etmenin yaratıcı bir yoludur.';
    case 'Bağış Yapmak':
        return 'Bağış yapmak, topluma katkıda bulunmanın ve diğerlerine yardım etmenin önemli bir yoludur.';
    case 'Düşünce Deneyleri Yapmak':
        return 'Düşünce deneyleri, yeni bakış açıları geliştirmenin ve yaratıcılığınızı artırmanın ilginç bir yoludur.';
    case 'Kendine Hedefler Belirlemek':
        return 'Kendinize hedefler belirlemek, motivasyonunuzu artırır ve başarıya ulaşmanıza yardımcı olur.';
    case 'Bir Rüya Günlüğü Tutmak':
        return 'Rüya günlüğü tutmak, bilinçaltınızı keşfetmenin ve kendinizi anlamanın bir yoludur.';
    case 'Bir Müzik Grubunda Yer Almak':
        return 'Müzik grubunda yer almak, müzik yeteneklerinizi geliştirmenizi ve eğlenceli zaman geçirmenizi sağlar.';
    case 'Sosyal Medya Yönetimi Yapmak':
        return 'Sosyal medya yönetimi, dijital becerilerinizi geliştirmenin ve iletişimde bulunmanın önemli bir yoludur.';
    case 'Bir Uygulama Geliştirmek':
        return 'Yeni bir uygulama geliştirmek, teknik becerilerinizi artırır ve yaratıcı projeler üretmenizi sağlar.';
    case 'Çizgi Film İzlemek':
        return 'Çizgi filmler, eğlenceli ve neşeli bir deneyim sunar.';
    case 'Bir Kütüphane Kurmak':
        return 'Kütüphane kurmak, topluma bilgi sağlamak ve okuma alışkanlığını teşvik etmek için önemlidir.';
    case 'Yardım Kuruluşlarına Destek Vermek':
        return 'Yardım kuruluşlarına destek vermek, topluma katkıda bulunmanın ve sosyal sorumluluk üstlenmenin güzel bir yoludur.';
    case 'Bir Kısa Film Çekmek':
        return 'Kısa film çekmek, yaratıcılığınızı ifade etmenin ve yeni beceriler kazanmanın eğlenceli bir yoludur.';
    case 'Gönüllü Faaliyetlere Katılmak':
        return 'Gönüllü faaliyetler, topluma katkıda bulunmanın ve yeni insanlarla tanışmanın harika bir yoludur.';
    case 'Bir Tiyatro Oyunu İzlemek':
        return 'Tiyatro, canlı performansların tadını çıkarabileceğiniz bir sanat biçimidir.';
    case 'Bir Hayvan Barınağına Yardımcı Olmak':
        return 'Hayvan barınaklarına yardımcı olmak, hayvanların yaşam koşullarını iyileştirmeye katkıda bulunur.';
    case 'Eğlenceli Bir Makale Yazmak':
        return 'Eğlenceli makaleler yazmak, yazma becerilerinizi geliştirmenin yanı sıra insanları bilgilendirir.';
    case 'Bir Blog Açmak':
        return 'Blog açmak, düşüncelerinizi paylaşmanın ve çevrimiçi bir topluluk oluşturmanın harika bir yoludur.';
    case 'Bir Deneme Yazmak':
        return 'Deneme yazmak, düşüncelerinizi derinlemesine keşfetmenin ve yazma becerilerinizi geliştirmek için önemli bir adımdır.';
    case 'Kısa Hikayeler Yazmak':
        return 'Kısa hikayeler yazmak, yaratıcılığınızı ifade etmenin ve yazma becerilerinizi geliştirmenin eğlenceli bir yoludur.';
    case 'Bir Resim Sergisi Açmak':
        return 'Resim sergisi açmak, sanatsal çalışmalarınızı sergilemenin ve toplulukla paylaşmanın harika bir yoludur.';
    case 'Bir Anket Yapmak':
        return 'Anket yapmak, belirli bir konuda fikirleri toplamanın ve veri analiz etmenin faydalı bir yoludur.';
    case 'Doğa Koruma Projelerine Katılmak':
        return 'Doğa koruma projelerine katılmak, çevre bilincinizi artırır ve ekosistemi korumanıza katkı sağlar.';
    case 'Bir Bilim Projesi Geliştirmek':
        return 'Bilim projeleri geliştirmek, bilimsel düşünme becerilerinizi artırır ve yeni keşifler yapmanıza yardımcı olur.';
    case 'Zaman Yönetimi Becerilerinizi Geliştirmek':
        return 'Zaman yönetimi becerilerinizi geliştirmek, verimliliğinizi artırır ve hedeflerinize ulaşmanıza yardımcı olur.';
    case 'Bir Online Kurs Almak':
        return 'Online kurslar almak, yeni beceriler öğrenmenizi ve bilgi dağarcığınızı genişletmenizi sağlar.';
    case 'Bir Podcast Dinlemek':
        return 'Podcast dinlemek, farklı bakış açıları kazanmanın ve eğitici içeriklere ulaşmanın harika bir yoludur.';
    case 'Bir Şiir Okumak':
        return 'Şiir okumak, edebiyatın tadını çıkarmanızın ve duygularınızı ifade etmenin güzel bir yoludur.';
    case 'Hedef Belirleme Seminerlerine Katılmak':
        return 'Hedef belirleme seminerleri, yaşamınıza yön vermenize yardımcı olur.';
    case 'Kişisel Gelişim Kitapları Okumak':
        return 'Kişisel gelişim kitapları, kendinizi geliştirmenize ve motivasyonunuzu artırmanıza yardımcı olur.';
    case 'Yaratıcı Yazım Atölyelerine Katılmak':
        return 'Yaratıcı yazım atölyeleri, yazma becerilerinizi geliştirmenize ve yaratıcılığınızı ifade etmenize yardımcı olur.';
    case 'Bir Oyun Geliştirmek':
        return 'Oyun geliştirmek, teknik ve yaratıcı becerilerinizi artırmanın eğlenceli bir yoludur.';
    case 'Bir Sanat Galerisi Gezmek':
        return 'Sanat galerileri, çeşitli sanat eserlerini görmenizi sağlar ve kültürel birikiminizi artırır.';
    case 'Bir Şarkı Yazmak':
        return 'Şarkı yazmak, duygularınızı müzikle ifade etmenin yaratıcı bir yoludur.';
    case 'Yardımcı Olmak':
        return 'Yardımcı olmak, başkalarına yardım etmenin ve sosyal sorumluluk üstlenmenin güzel bir yoludur.';
    case 'Geri Dönüşüm Bilincini Artırmak':
        return 'Geri dönüşüm bilincini artırmak, çevre bilincinizi güçlendirir.';
    case 'Sosyal Medyada Aktif Olmak':
        return 'Sosyal medyada aktif olmak, dijital iletişim becerilerinizi geliştirmenize yardımcı olur.';
    case 'Bir Yaşam Koçu Olmak':
        return 'Yaşam koçu olmak, başkalarına yol göstermenin ve kişisel gelişimlerini desteklemenin önemli bir yoludur.';
    case 'Bir Hobi Edinmek':
        return 'Yeni bir hobi edinmek, stres atmanın ve yeni şeyler öğrenmenin eğlenceli bir yoludur.';
    case 'Sanat ve Tasarım Projeleri Üretmek':
        return 'Sanat ve tasarım projeleri, yaratıcılığınızı ifade etmenin harika bir yoludur.';
    case 'Bir Film İzlemek':
        return 'Film izlemek, eğlenceli bir deneyim sunar ve farklı hikayeleri keşfetmenizi sağlar.';
    case 'Bir İnternet Sayfası Tasarlamak':
        return 'İnternet sayfası tasarlamak, dijital becerilerinizi geliştirmek ve yaratıcılığınızı sergilemek için harika bir fırsattır.';
    case 'Çocuklarla Zaman Geçirmek':
        return 'Çocuklarla vakit geçirmek, eğlenceli ve öğretici bir deneyim sunar.';
    case 'Seyahat Etmek':
        return 'Seyahat etmek, yeni yerler keşfetmenin ve farklı kültürlerle tanışmanın harika bir yoludur.';
    case 'Bir Müze Gezmek':
        return 'Müzeler, tarih ve kültür hakkında bilgi edinmenize yardımcı olur.';
    case 'Doğa Yürüyüşü Yapan İnsanlarla Tanışmak':
        return 'Doğa yürüyüşü yapan insanlarla tanışmak, sağlıklı yaşam tarzını benimsemenizi destekler.';
    case 'Bir Konser İzlemek':
        return 'Canlı konser izlemek, müziği ve sanatçıları yakından tanımanın heyecan verici bir yoludur.';
    case 'Günlük Yaşamda Stres Yönetimi Uygulamaları Geliştirmek':
        return 'Stres yönetimi uygulamaları, yaşam kalitenizi artırmanıza yardımcı olur.';
    case 'Bir Geliştirici Topluluğuna Katılmak':
        return 'Geliştirici toplulukları, bilgi paylaşımı ve işbirliği için mükemmel bir platform sağlar.';
    case 'Çocuklarla Eğitici Oyunlar Oynamak':
        return 'Çocuklarla eğitici oyunlar oynamak, öğrenmeyi eğlenceli hale getirir.';
    case 'Bir Yetişkin İçin Eğitim Programı Geliştirmek':
        return 'Yetişkinler için eğitim programları geliştirmek, bilgiyi paylaşmanın ve öğretici deneyimler sunmanın önemli bir yoludur.';
    case 'Sanat ve Kültürel Etkinliklere Katılmak':
        return 'Sanat ve kültürel etkinlikler, sosyal hayatınızı zenginleştirir ve yeni bakış açıları kazanmanızı sağlar.';
    case 'Dijital Pazarlama Eğitimi Almak':
        return 'Dijital pazarlama eğitimi, iş dünyasında önemli beceriler kazanmanıza yardımcı olur.';
    case 'Hobiler Üzerine Atölye Çalışmaları Yapmak':
        return 'Hobiler üzerine atölyeler, yeni yetenekler geliştirmenize ve sosyal çevrenizi genişletmenize yardımcı olur.';
    case 'Sosyal Medya İçerikleri Üretmek':
        return 'Sosyal medya içerikleri üretmek, yaratıcılığınızı ifade etmenin ve takipçi kitlenizi artırmanın harika bir yoludur.';
    case 'Bir Web Sitesi Geliştirmek':
        return 'Web sitesi geliştirmek, teknik becerilerinizi artırmanın ve dijital dünyada yer edinmenin önemlidir.';
    case 'Bir Duygusal Zeka Eğitimi Almak':
        return 'Duygusal zeka eğitimi, ilişkilerinizi güçlendirmenize ve sosyal becerilerinizi geliştirmenize yardımcı olur.';
    case 'Eğitimde Yenilikçi Yaklaşımlar Üretmek':
        return 'Eğitimde yenilikçi yaklaşımlar geliştirmek, öğrenme sürecini daha etkili hale getirir.';
    case 'Çevrimiçi Etkinliklere Katılmak':
        return 'Çevrimiçi etkinlikler, bilgi paylaşımı ve sosyal etkileşim için harika bir fırsattır.';
    case 'Kendi Çalışmalarını Yayınlamak':
        return 'Kendi çalışmanızı yayınlamak, bilgilerinizi paylaşmanın ve görünürlük kazanmanın önemli bir yoludur.';
    case 'Spor Etkinliklerine Katılmak':
        return 'Spor etkinliklerine katılmak, sağlıklı yaşamı teşvik eder ve sosyal çevrenizi genişletir.';
    case 'Kendi Yaşam Felsefenizi Geliştirmek':
        return 'Kendi yaşam felsefenizi geliştirmek, kişisel gelişiminizi destekler ve hayata farklı bir perspektiften bakmanıza yardımcı olur.';
    case 'Bir Blogda Yazmak':
        return 'Blogda yazmak, düşüncelerinizi paylaşmanın ve çevrimiçi bir topluluk oluşturmanın harika bir yoludur.';
    case 'Doğa Yürüyüşleri Düzenlemek':
        return 'Doğa yürüyüşleri düzenlemek, sağlıklı yaşamı teşvik eder ve toplulukla bağlantı kurmanıza yardımcı olur.';
    case 'Kendi Tarzınızı Oluşturmak':
        return 'Kendi tarzınızı oluşturmak, kişisel ifadenizi güçlendirir ve özgüveninizi artırır.';
    case 'Kendi Gelişiminizi Belgelemek':
        return 'Kendi gelişiminizi belgelemek, ilerlemenizi izlemenize ve motivasyonunuzu artırmanıza yardımcı olur.';
    default:
        return 'Bu aktivite hakkında bilgi bulunamadı.';
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activity Page")),
      body: BackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Aktivite: $suggestion",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text(
                  "Önerilen duygu durumu: $mood",
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Text(
                  getActivitySuggestion(suggestion),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: () {
                //     User user = FirebaseAuth.instance.currentUser!;
                //     _saveUserSelection(context, user.email!, mood, suggestion);
                //   },
                //   child: const Text("Bu Seçimi Kaydet"),
                // ),
                MyBotton(
                  text: "Etkinliği Onayla",
                  onTap: () => {
                    _approveActivity(context),
                    Navigator.pop(context),
                    Navigator.pushReplacementNamed(
                        context, '/apprrovedactivitiespage')
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
