实现一个简单 P2P 交易的 API
=======================

### 功能:

1. 每个用户有一个初始金额
2. 用户之间可以互相借钱
3. 用户之间可以相互还钱
4. 查询每个用户当前的余额、借出总额、借入总额以及任意两个用户之间当前的债务情况

### 需要提供的接口：

1. 创建用户接口，请求的参数支持设置初始金额、返回用户 ID
2. 创建一笔借款交易，参数是两个用户的 ID 和金额
3. 创建一笔还款交易，参数是两个用户的 ID 和金额
4. 查询一个用户的账户情况，参数是用户 ID，返回当前余额、借出总额和借入总额
5. 查询用户之间的债务情况，参数是两个用户的 ID，返回两者间当前的借入借出总额
