import 'package:bokrah/app/features/home/home_page.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // 👈 اجعل الصفحة RTL
      child: Scaffold(
        body: Row(
          children: [
            // Main login content
            Expanded(
              child: Center(
                child: Container(
                  width: 400,
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "تسجيل الدخول إلى بكره",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Email field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "الايميل",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Password field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "كلمة السر",
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: const Color(0xFF4CAF50),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return HomePage();
                                },
                              ),
                            );
                          },
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Forgot password
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "هل نسيت كلمة السر؟",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// if (_formKey.currentState!.validate()) {
                //   setState(() => _isLoading = true);

                //   try {
                //     // Prepare the API endpoint URL
                //     final Uri url = Uri.parse(
                //       'http://bokrah-api.runasp.net/api/Users/Login?email=${Uri.encodeComponent(_emailController.text)}&password=${Uri.encodeComponent(_passwordController.text)}',
                //     );

                //     // Make the GET request
                //     final response = await http.get(
                //       url,
                //       headers: {
                //         'accept': '*/*',
                //       },
                //     );

                //     setState(() => _isLoading = false);

                //     if (response.statusCode == 200) {
                //       // Login successful
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(content: Text('Login successful!')),
                //       );

                //       // Navigate to home page - using pushAndRemoveUntil to avoid page-based navigation issues
                //       PackageInfo packageInfo = await PackageInfo.fromPlatform();
                //       Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return HomePage(
                //    //     packageInfo: packageInfo,
                //       ); // AppUpdateScreen(packageInfo: packageInfo),
                //     },
                //   ),
                // );
                //     } else {
                //       // Login failed
                //       String errorMessage = 'Login failed';
                //       try {
                //         final responseData = json.decode(response.body);
                //         if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
                //           errorMessage = responseData['message'];
                //         }
                //       } catch (e) {
                //         // If JSON parsing fails, use the response body as is
                //         errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
                //       }

                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text(errorMessage)),
                //       );
                //     }
                //   } catch (error) {
                //     setState(() => _isLoading = false);
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('Network error: ${error.toString()}')),
                //     );
                //   }
                // }