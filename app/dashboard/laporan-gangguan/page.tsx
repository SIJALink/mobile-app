
"use client";

import { useState } from "react";

type Gangguan = {
  id: number;
  pelanggan: string;
  kategori: string;
  lokasi: string;
  tanggal: string;
  teknisi: string;
  keterangan: string;
  status: string;
};

export default function LaporanGangguan() {
  const [data, setData] = useState<Gangguan[]>([
    {
      id: 1,
      pelanggan: "Andi Saputra",
      kategori: "Internet Terputus",
      lokasi: "Pasar Kemis, Tangerang",
      tanggal: "20 November 2026",
      teknisi: "Budi Santoso",
      keterangan: "Koneksi internet pelanggan terputus sejak pagi.",
      status: "Menunggu",
    },
    {
      id: 2,
      pelanggan: "Siti Rahma",
      kategori: "Internet Lambat",
      lokasi: "Rajeg, Tangerang",
      tanggal: "21 November 2026",
      teknisi: "Dedi Kurniawan",
      keterangan: "Kecepatan internet tidak stabil.",
      status: "Diproses",
    },
    {
      id: 3,
      pelanggan: "Rizky Pratama",
      kategori: "Gangguan Kabel",
      lokasi: "Sepatan, Tangerang",
      tanggal: "22 November 2026",
      teknisi: "Andi Saputra",
      keterangan: "Gangguan pada jalur kabel jaringan.",
      status: "Selesai",
    },
    {
      id: 4,
      pelanggan: "Dewi Anggraini",
      kategori: "Modem Bermasalah",
      lokasi: "Cikupa, Tangerang",
      tanggal: "23 November 2026",
      teknisi: "Belum Ditugaskan",
      keterangan: "Modem tidak dapat terhubung ke jaringan.",
      status: "Menunggu",
    },
  ]);

  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [detail, setDetail] = useState<Gangguan | null>(null);

  const total = data.length;
  const menunggu = data.filter(
    (item) => item.status === "Menunggu"
  ).length;
  const diproses = data.filter(
    (item) => item.status === "Diproses"
  ).length;
  const selesai = data.filter(
    (item) => item.status === "Selesai"
  ).length;

  const dataFilter = data.filter((item) => {
    const cocokCari =
      item.pelanggan.toLowerCase().includes(cari.toLowerCase()) ||
      item.kategori.toLowerCase().includes(cari.toLowerCase()) ||
      item.lokasi.toLowerCase().includes(cari.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokCari && cocokStatus;
  });

  function ubahStatus(id: number, status: string) {
    setData((sebelumnya) =>
      sebelumnya.map((item) =>
        item.id === id ? { ...item, status } : item
      )
    );

    setDetail(null);
  }

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl">

        {/* HEADER */}
        <div className="mb-8">
          <p className="text-sm font-medium text-blue-600">
            Dashboard / Kepala SITE / Laporan Gangguan
          </p>

          <h1 className="mt-2 text-3xl font-bold text-slate-800">
            Laporan Gangguan
          </h1>

          <p className="mt-2 text-slate-500">
            Pantau laporan gangguan jaringan dan proses penanganannya.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="mb-8 grid grid-cols-1 gap-5 sm:grid-cols-2 xl:grid-cols-4">

          <div className="rounded-2xl bg-white p-6 shadow-sm">
            <p className="text-sm text-slate-500">Total Gangguan</p>
            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {total}
            </h2>
            <p className="mt-2 text-sm text-blue-600">
              Seluruh laporan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-6 shadow-sm">
            <p className="text-sm text-slate-500">Menunggu</p>
            <h2 className="mt-3 text-3xl font-bold text-yellow-600">
              {menunggu}
            </h2>
            <p className="mt-2 text-sm text-slate-500">
              Belum ditangani
            </p>
          </div>

          <div className="rounded-2xl bg-white p-6 shadow-sm">
            <p className="text-sm text-slate-500">Diproses</p>
            <h2 className="mt-3 text-3xl font-bold text-blue-600">
              {diproses}
            </h2>
            <p className="mt-2 text-sm text-slate-500">
              Sedang ditangani
            </p>
          </div>

          <div className="rounded-2xl bg-white p-6 shadow-sm">
            <p className="text-sm text-slate-500">Selesai</p>
            <h2 className="mt-3 text-3xl font-bold text-green-600">
              {selesai}
            </h2>
            <p className="mt-2 text-sm text-slate-500">
              Sudah ditangani
            </p>
          </div>

        </div>

        {/* TABEL */}
        <div className="overflow-hidden rounded-2xl bg-white shadow-sm">

          <div className="flex flex-col justify-between gap-4 border-b border-slate-100 p-6 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Data Laporan Gangguan
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Daftar gangguan pelanggan SIJALink
              </p>
            </div>

            <div className="flex flex-col gap-3 sm:flex-row">
              <input
                type="text"
                placeholder="Cari pelanggan, gangguan, lokasi..."
                value={cari}
                onChange={(e) => setCari(e.target.value)}
                className="rounded-xl border border-slate-200 px-4 py-2 text-sm outline-none focus:border-blue-500"
              />

              <select
                value={filter}
                onChange={(e) => setFilter(e.target.value)}
                className="rounded-xl border border-slate-200 px-4 py-2 text-sm outline-none focus:border-blue-500"
              >
                <option value="Semua">Semua Status</option>
                <option value="Menunggu">Menunggu</option>
                <option value="Diproses">Diproses</option>
                <option value="Selesai">Selesai</option>
              </select>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50 text-slate-600">
                <tr>
                  <th className="p-4">No</th>
                  <th className="p-4">Pelanggan</th>
                  <th className="p-4">Kategori Gangguan</th>
                  <th className="p-4">Lokasi</th>
                  <th className="p-4">Teknisi</th>
                  <th className="p-4">Status</th>
                  <th className="p-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {dataFilter.map((item, index) => (
                  <tr
                    key={item.id}
                    className="border-t border-slate-100 hover:bg-slate-50"
                  >
                    <td className="p-4">{index + 1}</td>

                    <td className="p-4 font-semibold text-slate-800">
                      {item.pelanggan}
                    </td>

                    <td className="p-4 text-slate-600">
                      {item.kategori}
                    </td>

                    <td className="p-4 text-slate-600">
                      {item.lokasi}
                    </td>

                    <td className="p-4 text-slate-600">
                      {item.teknisi}
                    </td>

                    <td className="p-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Selesai"
                            ? "bg-green-100 text-green-700"
                            : item.status === "Diproses"
                            ? "bg-blue-100 text-blue-700"
                            : "bg-yellow-100 text-yellow-700"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>

                    <td className="p-4">
                      <button
                        onClick={() => setDetail(item)}
                        className="rounded-lg bg-blue-600 px-4 py-2 text-xs font-semibold text-white hover:bg-blue-700"
                      >
                        Detail
                      </button>
                    </td>
                  </tr>
                ))}

                {dataFilter.length === 0 && (
                  <tr>
                    <td
                      colSpan={7}
                      className="p-8 text-center text-slate-500"
                    >
                      Laporan gangguan tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* MODAL DETAIL */}
        {detail && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl">

              <div className="mb-5 flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Gangguan
                </h2>

                <button
                  onClick={() => setDetail(null)}
                  className="text-2xl text-slate-400 hover:text-slate-700"
                >
                  ×
                </button>
              </div>

              <div className="space-y-4 text-sm">
                <div>
                  <p className="text-slate-500">Nama Pelanggan</p>
                  <p className="font-semibold text-slate-800">
                    {detail.pelanggan}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Kategori Gangguan</p>
                  <p className="font-semibold text-slate-800">
                    {detail.kategori}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Lokasi</p>
                  <p className="font-semibold text-slate-800">
                    {detail.lokasi}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Tanggal Laporan</p>
                  <p className="font-semibold text-slate-800">
                    {detail.tanggal}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Teknisi</p>
                  <p className="font-semibold text-slate-800">
                    {detail.teknisi}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Keterangan</p>
                  <p className="font-semibold text-slate-800">
                    {detail.keterangan}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Status</p>
                  <p className="font-semibold text-blue-600">
                    {detail.status}
                  </p>
                </div>
              </div>

              <div className="mt-7 border-t border-slate-100 pt-5">
                <p className="mb-3 text-sm font-semibold text-slate-700">
                  Ubah Status Gangguan
                </p>

                <div className="grid grid-cols-2 gap-3">
                  <button
                    onClick={() =>
                      ubahStatus(detail.id, "Diproses")
                    }
                    className="rounded-xl bg-blue-600 px-3 py-3 text-sm font-semibold text-white hover:bg-blue-700"
                  >
                    Proses
                  </button>

                  <button
                    onClick={() =>
                      ubahStatus(detail.id, "Selesai")
                    }
                    className="rounded-xl bg-green-600 px-3 py-3 text-sm font-semibold text-white hover:bg-green-700"
                  >
                    Selesaikan
                  </button>
                </div>
              </div>

            </div>
          </div>
        )}

      </div>
    </main>
  );
}
