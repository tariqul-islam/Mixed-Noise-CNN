import numpy as np
import tensorflow as tf
from scipy.io import loadmat

def conv_op(inp, W, b):
    o1 = tf.nn.conv2d(inp, W, strides=[1,1,1,1],padding="SAME")
    o2 = tf.nn.bias_add(o1,b)
    o3 = tf.nn.relu(o2)
    return o3, o2
    
def conv_op2(inp, W, b):
    o1 = tf.nn.conv2d(inp, W, strides=[1,1,1,1],padding="SAME")
    o2 = tf.nn.bias_add(o1,b)
    #o3 = tf.nn.relu(o2)
    return o2
    
def conv_op3(inp, W, b):
    o1 = tf.nn.conv2d(inp, W, strides=[1,1,1,1],padding="SAME")
    o2 = tf.nn.bias_add(o1,b)
    o3 = tf.nn.relu(o2)
    o4 = tf.nn.max_pool(o3, [1, 2, 2, 1], [1, 2, 2, 1], padding="SAME")
    return o4, o2
    
def model_loader(filename):
    d = loadmat(filename)
    for key in d:
        #var[key] = d[key].copy()
        if key[0] == 'b':
            d[key] = d[key].reshape(-1)
    #d.close()
    return d
    

class denoiser_net_pool2():
    def __init__(self, in_channel=1, out_channel=1, number_filter=[50,100,50], filter_size=[5,3,3,3], reg=0.0,
        is_load=False, filename='model.NN'):
        self.input_x = tf.placeholder(tf.float32, [None, None, None, in_channel])
        
        #Variables
        if is_load:
            var=model_loader(filename)
            W1 = tf.Variable(var["W1"],name="W1")
            b1 = tf.Variable(var["b1"],name="b1")
            W2 = tf.Variable(var["W2"],name="W2")
            b2 = tf.Variable(var["b2"],name="b2")
            W3 = tf.Variable(var["W3"],name="W3")
            b3 = tf.Variable(var["b3"],name="b3")
            W4 = tf.Variable(var["W4"],name="W4")
            b4 = tf.Variable(var["b4"],name="b4")
        else:
            fsh1 = [filter_size[0], filter_size[0], in_channel, number_filter[0]]
            W1 = tf.Variable(tf.truncated_normal(fsh1,stddev=0.01),name="W1")
            b1 = tf.Variable(tf.truncated_normal([number_filter[0]],stddev=0.01),name="b1")
            
            fsh2 = [filter_size[1], filter_size[1], number_filter[0], number_filter[1]]
            W2 = tf.Variable(tf.truncated_normal(fsh2,stddev=0.01),name="W2")
            b2 = tf.Variable(tf.truncated_normal([number_filter[1]],stddev=0.01),name="b2")
            
            fsh3 = [filter_size[2], filter_size[2], number_filter[1], number_filter[2]]
            W3 = tf.Variable(tf.truncated_normal(fsh3,stddev=0.01),name="W3")
            b3 = tf.Variable(tf.truncated_normal([number_filter[2]],stddev=0.01),name="b3")
            
            fsh4 = [filter_size[3], filter_size[3], number_filter[2], out_channel]
            W4 = tf.Variable(tf.truncated_normal(fsh4,stddev=0.01),name="W4")
            b4 = tf.Variable(tf.truncated_normal([out_channel],stddev=0.01),name="b4")
            
        
        #Network
        conv1,self.conv1 = conv_op3(self.input_x,W1,b1)
        conv2,self.conv2 = conv_op(conv1,W2,b2)
        conv3,self.conv3 = conv_op(conv2,W3,b3)
        self.conv4 = conv_op2(conv3,W4,b4)
        
        
        #output of the network
        self.out = self.conv4

        

