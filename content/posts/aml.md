---
title: Keras 手写数字识别
date: '2018-01-23 18:42:42'
tags:
- 机器学习
slug: aml
draft: false
---

---

之前机器学习课程布置的大作业是用尽可能多的模型来探索经典的手写数字识别问题。这里分享一下Keras的基本使用
<!--more-->

# Keras简介

Keras 是由纯 Python 写成的，调用 TensorFlow 或者 Theano（最新版本还支持 CNTK）进行运算的类库。相比于 TensorFlow，Keras 使用起来更加简洁方便，便于调参，非常适合初学者进行机器学习探索。

# 安装

在安装好 anaconda 的前提下，输入`conda install keras`即可进行安装。

注意到，安装过程会自动判断机器是否已经安装好了TensorFlow，如果没有的话会自动进行安装。所以，如果想安装 TensorFlow GPU 版本加速计算过程的话，要先手动安装好 TensorFlow 的 GPU 版本，然后再安装 Keras。

# 实现单层感知机

核心代码如下

```python
batch_size = 128
classes = 10
epoch = 10
img_size = 28 * 28

print('Loading Data...')
(X_train, y_train),(X_test,y_test) = mnist.load_data()

X_train = X_train.reshape(y_train.shape[0], img_size).astype('float32') / 255
X_test = X_test.reshape(y_test.shape[0], img_size).astype('float32') / 255

#encode labels
Y_train = np_utils.to_categorical(y_train,classes)
Y_test = np_utils.to_categorical(y_test,classes)


model = Sequential([Dense(10, input_shape=(img_size,), activation='softmax'),])
model.compile(optimizer='rmsprop', loss='mean_absolute_error', metrics=['accuracy'])

print("Training...")
model.fit(X_train, Y_train,batch_size=batch_size, epochs=epoch, verbose=1, validation_data=(X_test,Y_test))

score = model.evaluate(X_test,Y_test,verbose=0)

print('accuracy: {}'.format(score[1]))
```

前面很大一部分都是进行数据加载和处理，与模型有关的代码只有三行

`model = Sequential([Dense(10, input_shape=(img_size,), activation='softmax'),])`这一行是模型基本形态的定义，以图像的 size 作为输入，激活函数采用 softmax。

`model.compile(optimizer='rmsprop', loss='mean_absolute_error', metrics=['accuracy'])`这一行则是对模型的微观参数进行客制化。`optimizer`指定的是优化策略，`rmsprop`是一种改进的随机梯度下降策略。`loss`指的是损失函数。`metrics`是评估方法，这里用准确率进行评估。

`model.fit(X_train, Y_train,batch_size=batch_size, epochs=epoch, verbose=1, validation_data=(X_test,Y_test))`这一句是训练过程，指定训练数据，训练轮次（迭代次数），是否输出训练过程，验证数据。

# 多层全连接网络

核心代码部分

```python
model = Sequential([Dense(512,input_shape=(img_size,)),
                    Activation('relu'),
                    Dropout(0.2),
                    Dense(512, input_shape=(512,)),
                    Activation('relu'),
                    Dropout(0.2),
                    Dense(10,input_shape=(512,),activation='softmax')
                    ])
```

每一个 Dense 都是一个神经元训练层。训练层输出接 ReLU 激活函数层。如此类推。最后一层接单层感知机获取结果。值得注意的是两个 Dropout 层，用于应付过拟合问题，经过 Dropout 层会随机丢弃数据集中一定比率的激活值，同时将剩余的神经元的输出进行放大。

# 卷积神经网络

```python
model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),
                 activation='relu',
                 input_shape=input_shape))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))
```

卷积神经网络中主角变成了 Conv2D （卷积层）和 Pooling 层（池化）。