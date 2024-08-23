import Image from "next/image";
import Header from "./Components/Header";
import Herosec from "./Sections/Herosec";
import Whycashcare from "./Sections/Whycashcare";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col justify-between p-24 bg-white m-0 p-0">
      <Herosec />
      <Whycashcare />
    </main>
  );
}
