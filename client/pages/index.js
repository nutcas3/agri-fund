import React, { useEffect } from 'react';
import { useRouter } from 'next/router';
import { useDispatch, useSelector } from 'react-redux';
import { connectWithWallet } from '../helper/helper';
import { loadAccount } from '../redux/interactions';


export default function Home() {
  return (
    <main className="text-3xl font-bold underline">
      this is my world
    </main>
  );
}
