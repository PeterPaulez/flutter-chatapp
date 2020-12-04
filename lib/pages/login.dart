import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/socket.dart';
import 'package:chatapp/widgets/boton_form.dart';
import 'package:chatapp/widgets/custom_input.dart';
import 'package:chatapp/widgets/footer.dart';
import 'package:chatapp/widgets/header.dart';
import 'package:chatapp/utils/mostrarAlertas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          // mista vista de iOS y Android cuando se mueve
          physics: BouncingScrollPhysics(),
          child: Container(
            // Para que se estire todo
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(titulo: 'Chat APP'),
                _Form(),
                Footer(
                  route: 'register',
                  titulo: '¿No tienes cuenta?',
                  subtitulo: 'Crea tu cuenta!',
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
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

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            textController: passwordController,
            isPassword: true,
          ),
          BotonAzul(
            placeHolder: 'Ingresar',
            printData: {
              'emailController': emailController.text,
              'passwordController': passwordController.text
            },
            onPressed: authService.autenticando
                ? null
                : () async {
                    // Quitamos el foco este donde este y el teclado
                    FocusScope.of(context).unfocus();
                    final loginOK = await authService.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (loginOK) {
                      socketService.connect();
                      // Esto lo hacemos para que no puedan volver atrás al LoginPage
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlertaForm(
                          context, 'Fallo en el login', authService.msg);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
