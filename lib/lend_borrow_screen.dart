import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_project/constants.dart';
import 'package:test_project/dummy_swap.dart';
import 'package:test_project/lend_borrow.dart';
import 'package:web3dart/web3dart.dart';

class LendBorrowScreen extends StatefulWidget {
  const LendBorrowScreen({super.key});

  @override
  State<LendBorrowScreen> createState() => _LendBorrowScreenState();
}

class _LendBorrowScreenState extends State<LendBorrowScreen> {
  getData() async {
    userData = await WalletLendBorrow()
        .getUserData(userAddress: Constants.ethereumAddress);
    setState(() {});
  }

  var userData;
  @override
  void initState() {
    WalletLendBorrow().loadContracts();
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(userData.toString()),
          ElevatedButton(
            onPressed: () async {
              // DeployedContract? contract = await WalletLendBorrow.erc20Token;
              // log(contract!.abi.functions.toString());
              // var UserData = await WalletLendBorrow()
              //     .getUserData(UserAddress: Constants.ethereumAddress);

              // WalletLendBorrow().supply(
              //     address: "0x65aFADD39029741B3b8f0756952C74678c9cEC93",
              //     amount: 40000);
              // WalletLendBorrow()
              //     .getUserData(UserAddress: Constants.ethereumAddress);

              // log(UserData[3].toString());

              WalletLendBorrow().borrow(
                  ERC20address: "0xe9c4393a23246293a8D31BF7ab68c17d4CF90A29",
                  amount: 2);
              // WalletLendBorrow().repay(
              //     ERC20address: "0x65aFADD39029741B3b8f0756952C74678c9cEC93",
              //     amount:
              //         11579208923731620097252891909051370308410783478121767587393979691411963904);

              // WalletLendBorrow().borrow(
              //     ERC20address: "0xBa8DCeD3512925e52FE67b1b5329187589072A55",
              //     amount: 6,
              //     unwrap: true);
              // WalletLendBorrow().withdraw(
              //     ERC20address: "0x65aFADD39029741B3b8f0756952C74678c9cEC93",
              //     amount: 1000,
              //     unwrap: true);
              // WalletLendBorrow().repay(
              //   ERC20address: "0x65aFADD39029741B3b8f0756952C74678c9cEC93",
              //   repayType: 0,
              //   amount: 1000000,
              // );
              // WalletLendBorrow().toggleCollateral(
              //     ERC20address: "0x65aFADD39029741B3b8f0756952C74678c9cEC93",
              //     toggle: true);

              // var data = await WalletLendBorrow().getReservesData();
              // log(data.toString());
              // WalletLendBorrow().getTokenData();
            },
            child: Text("call"),
          ),
        ],
      )),
    );
  }
}
// DeployedContract approveContract = await loadAAVEContract();

//         var chainId = await ethClient.getChainId();
//         var gasPrice = await ethClient.getGasPrice();
//         var maxGas = await ethClient.estimateGas();
//         try {
//           var trans = await ethClient.sendTransaction(
//               chainId: chainId.toInt(),
//               Constants.userCredentials,
//               Transaction.callContract(
//                   gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
//                   contract: approveContract,
//                   maxGas: 300000,
//                   function:
//                       approveContract.function("setUserUseReserveAsCollateral"),
//                   parameters: [
//                     EthereumAddress.fromHex(
//                         "0x2E8D98fd126a32362F2Bd8aA427E59a1ec63F780"),
//                     false,
//                   ]));
//           log(trans);
//         } catch (e) {
//           log(e.toString());
//         }