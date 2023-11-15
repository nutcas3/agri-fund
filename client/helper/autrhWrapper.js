
import Navbar from "../components/Navbar";

export const getLocalStorageData = (name) =>{
  var value;
  if (typeof window !== "undefined") {
  value = localStorage.getItem(name)
  }
  return value
}

const authWrapper = (WrappedComponent) => {
  // eslint-disable-next-line react/display-name
  return (props) => {

        return (
          <>
            <Navbar />
            <WrappedComponent {...props} />
          </>
        )
  };
};

export default authWrapper;
