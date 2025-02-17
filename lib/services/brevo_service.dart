import 'dart:convert';
import 'package:http/http.dart' as http;

class BrevoService {
  final String apiKey = 'your-api-key-here'; // Replace with your actual API key
  final String senderEmail = 'your@email.com'; // Replace with your sender email

  Future<bool> sendEmail(String recipientEmail, String subject, String message) async {
    final url = Uri.parse('https://api.brevo.com/v3/smtp/email');

    final headers = {
      'accept': 'application/json',
      'api-key': apiKey,
      'content-type': 'application/json',
    };

    final body = jsonEncode({
      "sender": {"email": senderEmail, "name": "Velo App"},
      "to": [
        {"email": recipientEmail, "name": "Recipient"}
      ],
      "subject": subject,
      "htmlContent": "<p>$message</p>"
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print("✅ Email sent successfully!");
        return true;
      } else {
        print("❌ Failed to send email: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error: $e");
      return false;
    }
  }
}
