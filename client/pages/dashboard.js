import React from "react";
import authWrapper from "../helper/authWrapper";
import AgriRaiserForm from "../components/AgriRaiserForm";
import { useSelector } from "react-redux";
import AgriRaiserCard from "../components/AgriRaiserCard";
import Loader from "../components/Loader";

const Dashboard = ()=> {
    const projectsList = useSelector(state=>state.projectreducer.projects)

    return (
        <div className="px-2 py-4 flex flex-col lg:px-12 lg:flex-row ">
          <div className="lg:w-7/12 my-2 lg:my-0 lg:mx-2">
            {projectsList !== undefined?
              projectsList.length > 0 ?
                projectsList.map((data, i) => (
                  <AgriRaiserCard props={data} key={i}/>
                ))
              :
              <h1 className="text-2xl font-bold text-gray-500 text-center font-sans">No project found !</h1>
            :
            <Loader/>
          }
          </div>
          <div className="card lg:w-5/12 h-fit my-4">
              <AgriRaiserForm/>
          </div>
        </div>
      );
}
export default authWrapper(D)