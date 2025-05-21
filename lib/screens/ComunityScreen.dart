import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Map<String, dynamic>> posts = [
    {
      'username': 'CocinaConLuz',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
      'caption': 'Hoy hice esta pasta cremosa con champiñones 😍 ¿Qué opinan?',
      'liked': false,
    },
    {
      'username': 'ChefSaludable',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'image': 'https://www.semana.com/resizer/v2/PVWQHU2FA5DJXD5ETNR424UIEE.jpg?auth=90bf1d8d43dcf1a49697d00c4e7c399a7945d4f579700e26eb3f2d0aa15f2b3a&smart=true&quality=75&width=1280&height=720',
      'caption': 'Consejo: siempre remoja las lentejas antes de cocinarlas, ¡te ahorras tiempo y mejora la digestión!',
      'liked': false,
    },
    {
      'username': 'PostresMagicos',
      'avatar': 'https://i.pravatar.cc/150?img=7',
      'image': 'https://www.recetasnestle.cl/sites/default/files/styles/recipe_detail_desktop_new/public/srh_recipes/6a60d55d0a1ccf2f24b4cc6b961adb5f.webp?itok=QBh7zYM4',
      'caption': '¿Quién quiere receta de este cheesecake de maracuyá? 🍰💛',
      'liked': false,
    },
  ];

  final Map<int, bool> showCommentInput = {};

  void toggleLike(int index) {
    setState(() {
      posts[index]['liked'] = !(posts[index]['liked'] as bool);
    });
  }

  void toggleCommentInput(int index) {
    setState(() {
      showCommentInput[index] = !(showCommentInput[index] ?? false);
    });
  }

  void simulateShare(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Compartir publicación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  ShareIcon(icon: Icons.chat, label: 'WhatsApp'),
                  ShareIcon(icon: Icons.facebook, label: 'Facebook'),
                  ShareIcon(icon: Icons.email, label: 'Email'),
                  ShareIcon(icon: Icons.link, label: 'Copiar link'),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(post['avatar'])),
                  title: Text(post['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(post['image'], fit: BoxFit.cover, width: double.infinity, height: 200),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post['caption']),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(post['liked'] ? Icons.favorite : Icons.favorite_border, color: post['liked'] ? Colors.red : null),
                      onPressed: () => toggleLike(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () => toggleCommentInput(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => simulateShare(context),
                    ),
                  ],
                ),
                if (showCommentInput[index] ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(hintText: 'Escribe un comentario...'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Comentario enviado (simulado)')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShareIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const ShareIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          radius: 24,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
