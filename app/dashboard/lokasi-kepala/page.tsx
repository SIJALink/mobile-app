
"use client";

import { useState } from "react";

type Teknisi = {
  id: number;
  nama: string;
  kode: string;
  jabatan: string;
  wilayah: string;
  status: "Berbagi Lokasi" | "Tidak Berbagi";
  durasi: string;
  terakhir: string;
  baterai: number;
  latitude: string;
  longitude: string;
};

const dataAwal: Teknisi[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    kode: "TKN-001",
    jabatan: "Teknisi Lapangan",
    wilayah: "Area Utama",
    status: "Berbagi Lokasi",
    durasi: "8 Jam",
    terakhir: "2 menit lalu",
    baterai: 85,
    latitude: "-6.1702",
    longitude: "106.6403",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    kode: "TKN-002",
    jabatan: "Teknisi Lapangan",
    wilayah: "Area Timur",
    status: "Berbagi Lokasi",
    durasi: "4 Jam",
    terakhir: "5 menit lalu",
    baterai: 70,
    latitude: "-6.1710",
    longitude: "106.6450",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    kode: "TKN-003",
    jabatan: "Teknisi Lapangan",
    wilayah: "Area Barat",
    status: "Tidak Berbagi",
    durasi: "-",
    terakhir: "1 jam lalu",
    baterai: 45,
    latitude: "-",
    longitude: "-",
  },
  {
    id: 4,
    nama: "Rizky Pratama",
    kode: "TKN-004",
    jabatan: "Supervisor",
    wilayah: "Area Selatan",
    status: "Berbagi Lokasi",
    durasi: "8 Jam",
    terakhir: "1 menit lalu",
    baterai: 92,
    latitude: "-6.1750",
    longitude: "106.6500",
  },
];

export default function LokasiKepalaPage() {
  const [data] = useState(dataAwal);
  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [detail, setDetail] = useState<Teknisi | null>(null);

  const aktif = data.filter(
    (item) => item.status === "Berbagi Lokasi"
  ).length;

  const tidakAktif = data.filter(
    (item) => item.status === "Tidak Berbagi"
  ).length;

  const hasilFilter = data.filter((item) => {
    const cocokCari =
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.wilayah.toLowerCase().includes(cari.toLowerCase()) ||
      item.kode.toLowerCase().includes(cari.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokCari && cocokStatus;
  });

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Kepala SITE / Monitoring Lokasi
          </p>

          <h1 className="mt-2 text-2xl font-bold text-slate-800 md:text-3xl">
            Monitoring Live Location Teknisi
          </h1>

          <p className="mt-2 text-sm text-slate-500">
            Pantau status berbagi lokasi teknisi lapangan.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">
              Total Teknisi
            </p>
            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {data.length}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Teknisi terdaftar
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">
              Sedang Berbagi Lokasi
            </p>
            <h2 className="mt-3 text-3xl font-bold text-green-600">
              {aktif}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Lokasi dibagikan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">
              Tidak Berbagi Lokasi
            </p>
            <h2 className="mt-3 text-3xl font-bold text-orange-500">
              {tidakAktif}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Lokasi tidak dibagikan
            </p>
          </div>

        </div>

        {/* PETA ILUSTRASI */}
        <section className="overflow-hidden rounded-2xl bg-white shadow-sm">

          <div className="border-b border-slate-100 p-5">
            <h2 className="text-lg font-bold text-slate-800">
              Peta Monitoring Teknisi
            </h2>
            <p className="mt-1 text-sm text-slate-500">
              Ilustrasi sebaran lokasi teknisi.
            </p>
          </div>

          <div className="relative flex min-h-[300px] items-center justify-center overflow-hidden bg-slate-200 p-5">

            <div className="absolute inset-0 opacity-40">
              <div className="grid h-full grid-cols-6 grid-rows-5">
                {Array.from({ length: 30 }).map((_, index) => (
                  <div
                    key={index}
                    className="border border-white"
                  />
                ))}
              </div>
            </div>

            <div className="relative grid w-full max-w-2xl grid-cols-2 gap-4 md:grid-cols-3">

              {data
                .filter((item) => item.status === "Berbagi Lokasi")
                .map((item) => (
                  <button
                    key={item.id}
                    onClick={() => setDetail(item)}
                    className="rounded-xl border border-white bg-white p-4 text-left shadow-lg transition hover:-translate-y-1"
                  >
                    <div className="flex items-center gap-2">
                      <span className="flex h-9 w-9 items-center justify-center rounded-full bg-green-100 text-lg">
                        📍
                      </span>
                      <span className="h-2 w-2 rounded-full bg-green-500" />
                    </div>

                    <p className="mt-3 text-sm font-bold text-slate-800">
                      {item.nama}
                    </p>

                    <p className="mt-1 text-xs text-slate-500">
                      {item.wilayah}
                    </p>
                  </button>
                ))}

            </div>

          </div>

          <div className="flex flex-wrap gap-4 border-t border-slate-100 p-4 text-xs text-slate-500">
            <span>🟢 Sedang berbagi lokasi</span>
            <span>🟠 Tidak berbagi lokasi</span>
          </div>

        </section>

        {/* DAFTAR TEKNISI */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">

          <div className="flex flex-col justify-between gap-4 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Daftar Lokasi Teknisi
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Informasi status dan pembaruan lokasi teknisi.
              </p>
            </div>

            <input
              type="text"
              placeholder="Cari nama, ID, atau wilayah..."
              value={cari}
              onChange={(e) => setCari(e.target.value)}
              className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 md:w-80"
            />
          </div>

          {/* FILTER */}
          <div className="mt-5 flex flex-wrap gap-2">
            {[
              "Semua",
              "Berbagi Lokasi",
              "Tidak Berbagi",
            ].map((item) => (
              <button
                key={item}
                onClick={() => setFilter(item)}
                className={`rounded-xl px-4 py-2 text-sm font-semibold ${
                  filter === item
                    ? "bg-blue-600 text-white"
                    : "bg-slate-100 text-slate-600 hover:bg-slate-200"
                }`}
              >
                {item}
              </button>
            ))}
          </div>

          {/* TABEL */}
          <div className="mt-5 overflow-x-auto">
            <table className="w-full min-w-[850px] text-left text-sm">
              <thead>
                <tr className="border-b bg-slate-50 text-slate-500">
                  <th className="px-4 py-4">No</th>
                  <th className="px-4 py-4">Nama Teknisi</th>
                  <th className="px-4 py-4">ID</th>
                  <th className="px-4 py-4">Wilayah</th>
                  <th className="px-4 py-4">Durasi</th>
                  <th className="px-4 py-4">Pembaruan Terakhir</th>
                  <th className="px-4 py-4">Status</th>
                  <th className="px-4 py-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {hasilFilter.map((item, index) => (
                  <tr
                    key={item.id}
                    className="border-b border-slate-100 hover:bg-slate-50"
                  >
                    <td className="px-4 py-4">{index + 1}</td>

                    <td className="px-4 py-4 font-semibold text-slate-700">
                      {item.nama}
                    </td>

                    <td className="px-4 py-4 text-slate-500">
                      {item.kode}
                    </td>

                    <td className="px-4 py-4">{item.wilayah}</td>

                    <td className="px-4 py-4">{item.durasi}</td>

                    <td className="px-4 py-4 text-slate-500">
                      {item.terakhir}
                    </td>

                    <td className="px-4 py-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Berbagi Lokasi"
                            ? "bg-green-100 text-green-700"
                            : "bg-orange-100 text-orange-700"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>

                    <td className="px-4 py-4">
                      <button
                        onClick={() => setDetail(item)}
                        className="rounded-lg bg-blue-50 px-3 py-2 text-xs font-semibold text-blue-600 hover:bg-blue-100"
                      >
                        Detail
                      </button>
                    </td>
                  </tr>
                ))}

                {hasilFilter.length === 0 && (
                  <tr>
                    <td
                      colSpan={8}
                      className="px-4 py-10 text-center text-slate-400"
                    >
                      Data teknisi tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

        </section>

        {/* DETAIL TEKNISI */}
        {detail && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="w-full max-w-md rounded-2xl bg-white p-6 shadow-xl">

              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Lokasi Teknisi
                </h2>

                <button
                  onClick={() => setDetail(null)}
                  className="text-2xl text-slate-400"
                >
                  ×
                </button>
              </div>

              <div className="mt-5 space-y-4">

                <div>
                  <p className="text-xs text-slate-400">Nama Teknisi</p>
                  <p className="font-semibold text-slate-800">
                    {detail.nama}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">ID Teknisi</p>
                  <p className="font-semibold text-slate-800">
                    {detail.kode}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Jabatan</p>
                  <p className="font-semibold text-slate-800">
                    {detail.jabatan}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Wilayah</p>
                  <p className="font-semibold text-slate-800">
                    {detail.wilayah}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Durasi Berbagi</p>
                  <p className="font-semibold text-slate-800">
                    {detail.durasi}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Pembaruan Terakhir</p>
                  <p className="font-semibold text-slate-800">
                    {detail.terakhir}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Baterai</p>
                  <p className="font-semibold text-slate-800">
                    {detail.baterai}%
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Koordinat Contoh</p>
                  <p className="font-semibold text-slate-800">
                    {detail.latitude}, {detail.longitude}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Status</p>
                  <p className="font-semibold text-slate-800">
                    {detail.status}
                  </p>
                </div>

              </div>

              <button
                onClick={() => setDetail(null)}
                className="mt-6 w-full rounded-xl bg-blue-600 py-3 text-sm font-semibold text-white hover:bg-blue-700"
              >
                Tutup
              </button>

            </div>
          </div>
        )}

      </div>
    </main>
  );
}
