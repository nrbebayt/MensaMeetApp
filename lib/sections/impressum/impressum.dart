import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../auth/authentication_service.dart';
import '../auth_home_wrapper.dart';
import '../supportClass/_Images.dart';



class Impressum extends StatelessWidget {
  const Impressum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: HexColor("F3EBDD"),
        title: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: SvgPicture.asset(Images.logo_light),

        ),
        flexibleSpace: FlexibleSpaceBar(
          background: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(Images.appbar_bot,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
              onPressed:() async{
                await AuthenticationService().logout();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AuthHomeWrapper()));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(Icons.home),
              label: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white)
              )
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Impressum',
                ),
                Align(
                  alignment: AlignmentDirectional(-1, -1),
                  child: Text(
                    'Verantwortlich für den Inhalt dieser App gemäß § 5 TMG:\n\nKontakt:\nBerkay Baytekin\nOkan Biyikli\n\nTelefon: +123 456 789\nE-Mail: mensameet@support.de\n\nVertreten durch:\n\nBerkay Baytekin\nOkan Biyikli\n\nUmsatzsteuer-Identifikationsnummer:\n\n123456789\n\nRegistereintrag:\n\nEintragung im Handelsregister.\nRegistergericht: Bottrop\nRegisternummer: 1234567896\n\nBerufshaftpflichtversicherung:\n\nName und Sitz der Gesellschaft:\nAOK\n123456789\n\nVerantwortlich für journalistisch-redaktionelle Inhalte:\n\nOkan Biyikli\n\nHaftungsausschluss:\n\nDie Inhalte dieser Website wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen.\nBerkay haftet mit vollem privaten Vermögen. \n\nUrheberrecht:\n\nDie durch den Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechts bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.\n\nDatenschutz:\n\nInformationen zum Datenschutz findest du in unserer Datenschutzerklärung \n\nOnline-Streitbeilegung:\n\nDie Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung (OS) bereit: Unsere E-Mail-Adresse finden Sie oben im Impressum.\n\nUnsere Website verwendet Cookies. Dabei handelt es sich um kleine Textdateien, die auf deinem Endgerät gespeichert werden. Sie richten keinen Schaden an und enthalten keine Viren. Cookies dienen dazu, unser Angebot nutzerfreundlicher, effektiver und sicherer zu machen.\n\nEinige Cookies sind \"Session-Cookies\". Solche Cookies werden nach Ende deiner Browser-Sitzung von selbst gelöscht. Andere Cookies bleiben auf deinem Endgerät gespeichert, bis du diese selbst löschst. Diese Cookies ermöglichen es uns, deinen Browser beim nächsten Besuch wiederzuerkennen.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
