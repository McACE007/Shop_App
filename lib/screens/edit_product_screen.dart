import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../models/edit_product_model.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = "/edit-product-screen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _editedProduct = ProductTemp(
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  var _isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        final product = Provider.of<ProductsProvider>(context)
            .findById(productId.toString());
        _editedProduct.id = product.id;
        _editedProduct.title = product.title;
        _editedProduct.description = product.description;
        _editedProduct.price = product.price;
        _editedProduct.imageUrl = product.imageUrl;
        _editedProduct.isFavorite = product.isFavorite;
        _imageUrlController.text = product.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    final productData = Provider.of<ProductsProvider>(context, listen: false);
    if (_editedProduct.id.isEmpty) {
      await productData.addProduct(_editedProduct);
    } else {
      await productData.updateProduct(_editedProduct);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(label: Text("Title")),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a Title.";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (newValue) => _editedProduct.title = newValue!,
                      initialValue: _editedProduct.title,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(label: Text("Price")),
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (newValue) =>
                          _editedProduct.price = double.parse(newValue!),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a Price.";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter a valid price.";
                        }
                        if (double.parse(value) <= 0) {
                          return "Enter a price greater than zero.";
                        }
                        return null;
                      },
                      initialValue: _editedProduct.price.toString(),
                    ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      decoration:
                          const InputDecoration(label: Text("Description")),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (newValue) =>
                          _editedProduct.description = newValue!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a Description.";
                        }
                        return null;
                      },
                      initialValue: _editedProduct.description,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text("Enter a URL")
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(label: Text("Title")),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (newValue) =>
                                _editedProduct.imageUrl = newValue!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a Image URL.";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
