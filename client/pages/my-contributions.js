import React, { useEffect, useState } from 'react'
import { useSelector } from 'react-redux'
import Loader from '../components/Loader'
import authWrapper from '../helper/authWrapper'
import { getMyContributionList } from '../redux/interactions'
import Link from "next/link";


const MyContributions = () => {

    const crowdFundingContract = useSelector(state=>state.fundingReducer.contract)
    const account = useSelector(state=>state.web3Reducer.account)

    const [contributions, setContributions] = useState(null)

    useEffect(() => {
        (async() => {
            if(crowdFundingContract){
                var res = await getMyContributionList(crowdFundingContract,account)
                console.log(res)
                setContributions(res)
            }
        })();
    }, [crowdFundingContract])

}


export default authWrapper(MyContributions)