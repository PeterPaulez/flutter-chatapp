import 'package:chatapp/services/auth.dart';
import 'package:chatapp/utils/mostrarAlertas.dart';
import 'package:chatapp/widgets/boton_form.dart';
import 'package:chatapp/widgets/custom_input.dart';
import 'package:chatapp/widgets/footer.dart';
import 'package:chatapp/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          // mista vista de iOS y Android cuando se mueve
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(titulo: 'Register'),
                _Form(),
                Footer(
                  route: 'login',
                  titulo: '¿Ya tienes cuenta?',
                  subtitulo: 'Ingresa en tu cuenta!',
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre',
            textController: nameController,
          ),
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
            placeHolder: 'Crear cuenta',
            printData: {
              'emailController': emailController.text,
              'passwordController': passwordController.text,
              'nameController': nameController.text
            },
            onPressed: authService.autenticando
                ? null
                : () async {
                    // Quitamos el foco este donde este y el teclado
                    FocusScope.of(context).unfocus();
                    final registerOK = await authService.register(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      nameController.text.trim(),
                    );

                    if (registerOK) {
                      // TODO: conectar con socket service, mandando credenciales
                      // Esto lo hacemos para que no puedan volver atrás al LoginPage
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlertaForm(
                          context, 'Fallo en el Registro', authService.msg);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
