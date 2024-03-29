# NFTDGSTV：Infrared Small Target Detection via Nonconvex Tensor Tucker Decomposition with Factor Prior
**Matlab implementation of "*Infrared Small Target Detection via Nonconvex Tensor Tucker Decomposition with Factor Prior*", 
## *Highlights:*
#### 1. * (a) Inspired by the theorem that n-rank is upper bounded by the rank of each Tucker factor matrix, we propose a nonconvex tensor Tucker decomposition model
with factors prior for infrared small target detection. In our method, we use logdet-based function to constrain the latent factors of low-rank Tucker decomposition, which avoids empirical rank selection and sufficiently uses the latent data structure information in the factor matrix. Meanwhile, performing SVD calculations on small factor matrices can reduce computational complexity.* (b) Group sparsity regularized total variation is used to better exploit the shared sparse pattern of difference images, which helps better remove background clutter and obtain better detection results.*
 <p align="center"> <img src="https://raw.github.com/LiuTing20a/NFTDGSTV/master/Figs/flow.png" width="90%"> </p>
 
 #### 2. *To demonstrate the advantages of the NFTDGSTV method, we compare it with other eiught methods on six different real infrared image scenes.*
 <p align="center"> <img src="https://raw.github.com/LiuTing20a/NFTDGSTV/master/Figs/ZST1.png" width="90%"> </p>
 <p align="center"> <img src="https://raw.github.com/LiuTing20a/NFTDGSTV/master/Figs/ZST2.png" width="90%"> </p>
 
## Get Started
Run Demo_NFTDGSTV.

## Details
For details such as parameter setting, please refer to [<a href="https://ieeexplore.ieee.org/document/10190750">pdf</a>].


## Citation

```
  @article{liu2023infrared,
  title={Infrared Small Target Detection via Nonconvex Tensor Tucker Decomposition with Factor Prior},
  author={Liu, Ting and Yang, Jungang and Li, Boyang and Wang, Yingqian and An, Wei},
  journal={IEEE Transactions on Geoscience and Remote Sensing},
  year={2023},
  publisher={IEEE}
}
  

```

## Contact
**Any question regarding this work can be addressed to [liuting@nudt.edu.cn](liuting@nudt.edu.cn).**

