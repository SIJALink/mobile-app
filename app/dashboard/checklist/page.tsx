
"use client";

import { useState } from "react";
import Link from "next/link";

type Checklist = {
  id: number;
  nama: string;
  tanggal: string;
  jadwal: string;
  lokasi: string;
  kegiatan: string[];
  status: string;
};

const dataAwal: Checklist[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    tanggal: "2026-11-23",
    jadwal: "07:00 - 12:00",
    lokasi: "Area Sekolah A",
    kegiatan: [
      "Memeriksa kebersihan lingkungan",
      "Memeriksa kehadiran siswa piket",
      "Memantau kegiatan siswa",
      "Mengisi laporan kegiatan",
    ],
    status: "Selesai",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    tanggal: "2026-11-23",
    jadwal: "07:00 - 12:00",
    lokasi: "Area Sekolah B",
    kegiatan: [
      "Memeriksa kebersihan lingkungan",
      "Memeriksa kehadiran siswa piket",
      "Memantau kegiatan siswa",
      "Mengisi laporan kegiatan",
    ],
    status: "Berlangsung",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    tanggal: "2026-11-24",
    jadwal: "07:00 - 12:00",
    lokasi: "Area Sekolah A",
    kegiatan: [
      "Memeriksa kebersihan lingkungan",
      "Memeriksa kehadiran siswa piket",
      "Memantau kegiatan siswa",
      "Mengisi laporan kegiatan",
    ],
    status: "Belum Dimulai",
  },
];

export default function ChecklistPage() {
  const [data, setData] = useState<Checklist[]>(dataAwal);
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [detail, setDetail] = useState<Checklist | null>(null);

  const total = data.length;
  const selesai = data.filter(
    (item) => item.status === "Selesai"
  ).length;
  const berlangsung = data.filter(
    (item) => item.status === "Berlangsung"
  ).length;
  const belum = data.filter(
    (item) => item.status === "Belum Dimulai"
  ).length;

  const hasilFilter = data.filter((item) => {
    const cocokNama = item.nama
      .toLowerCase()
      .includes(search.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokNama && cocokStatus;
  });

  function ubahChecklist(index: number) {
    if (!detail) return;

    const kegiatanBaru = [...detail.kegiatan];
    kegiatanBaru[index] =
      kegiatanBaru[index].startsWith("✓ ")
        ? kegiatanBaru[index].replace("✓ ", "")
        : "✓ " + kegiatanBaru[index];

    const dataBaru = {
      ...detail,
      kegiatan: kegiatanBaru,
    };

    const jumlahSelesai = kegiatanBaru.filter(
      (item) => item.startsWith("✓ ")
    ).length;

    const statusBaru =
      jumlahSelesai === kegiatanBaru.length
        ? "Selesai"
        : jumlahSelesai > 0
        ? "Berlangsung"
        : "Belum Dimulai";

    dataBaru.status = statusBaru;

    setData((lama) =>
      lama.map((item) =>
        item.id === detail.id ? dataBaru : item
      )
    );

    setDetail(dataBaru);
  }

  function hitungPersen(kegiatan: string[]) {
    const jumlahSelesai = kegiatan.filter(
      (item) => item.startsWith("✓ ")
    ).length;

    return Math.round(
      (jumlahSelesai / kegiatan.length) * 100
    );
  }

  return (
    <main className="min-h-screen bg-[#f2f7ff] p-4 text-[#102d60] sm:p-6 lg:p-8">
      <div className="mx-auto max-w-7xl">

        {/* HEADER */}
        <div className="mb-8">
          <Link
            href="/dashboard"
            className="text-sm font-semibold text-blue-600 hover:underline"
          >
            ← Kembali ke Dashboard
          </Link>

          <h1 className="mt-3 text-2xl font-bold sm:text-3xl">
            Monitoring Checklist Guru Piket
          </h1>

          <p className="mt-2 text-sm text-slate-500">
            Pantau pelaksanaan tugas dan checklist Guru Piket.
          </p>
        </div>

        {/* STATISTIK */}
        <section className="mb-8 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
          <StatCard
            judul="Total Guru Piket"
            angka={total}
            icon="👥"
            warna="bg-blue-600"
          />
          <StatCard
            judul="Checklist Selesai"
            angka={selesai}
            icon="✓"
            warna="bg-emerald-600"
          />
          <StatCard
            judul="Sedang Berlangsung"
            angka={berlangsung}
            icon="⏳"
            warna="bg-sky-500"
          />
          <StatCard
            judul="Belum Dimulai"
            angka={belum}
            icon="📝"
            warna="bg-amber-500"
          />
        </section>

        {/* DAFTAR CHECKLIST */}
        <section className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm sm:p-6">

          <div className="mb-6">
            <h2 className="text-xl font-bold">
              Daftar Checklist Aktivitas
            </h2>
            <p className="mt-1 text-sm text-slate-500">
              Informasi kegiatan Guru Piket berdasarkan jadwal.
            </p>
          </div>

          <div className="mb-5 flex flex-col gap-3 md:flex-row">
            <input
              type="text"
              placeholder="Cari nama Guru Piket..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full rounded-xl border border-slate-200 p-3 outline-none focus:border-blue-500"
            />

            <select
              value={filter}
              onChange={(e) => setFilter(e.target.value)}
              className="rounded-xl border border-slate-200 p-3 outline-none"
            >
              <option value="Semua">Semua Status</option>
              <option value="Selesai">Selesai</option>
              <option value="Berlangsung">Berlangsung</option>
              <option value="Belum Dimulai">Belum Dimulai</option>
            </select>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full min-w-[800px] text-left text-sm">
              <thead className="bg-slate-100 text-slate-600">
                <tr>
                  <th className="rounded-l-lg p-4">No</th>
                  <th className="p-4">Nama Guru</th>
                  <th className="p-4">Tanggal</th>
                  <th className="p-4">Waktu</th>
                  <th className="p-4">Progress</th>
                  <th className="p-4">Status</th>
                  <th className="rounded-r-lg p-4">Detail</th>
                </tr>
              </thead>

              <tbody>
                {hasilFilter.map((item, index) => {
                  const persen = hitungPersen(item.kegiatan);

                  return (
                    <tr
                      key={item.id}
                      className="border-b border-slate-100 hover:bg-slate-50"
                    >
                      <td className="p-4">{index + 1}</td>

                      <td className="p-4 font-semibold">
                        {item.nama}
                        <p className="mt-1 text-xs font-normal text-slate-500">
                          {item.lokasi}
                        </p>
                      </td>

                      <td className="p-4">{item.tanggal}</td>
                      <td className="p-4">{item.jadwal}</td>

                      <td className="p-4">
                        <div className="mb-2 flex justify-between text-xs">
                          <span>{persen}%</span>
                          <span className="text-slate-400">
                            {item.kegiatan.filter((k) =>
                              k.startsWith("✓ ")
                            ).length}/{item.kegiatan.length}
                          </span>
                        </div>

                        <div className="h-2 w-28 overflow-hidden rounded-full bg-slate-200">
                          <div
                            className="h-full rounded-full bg-blue-600"
                            style={{ width: `${persen}%` }}
                          />
                        </div>
                      </td>

                      <td className="p-4">
                        <span
                          className={`rounded-full px-3 py-1 text-xs font-semibold ${
                            item.status === "Selesai"
                              ? "bg-emerald-100 text-emerald-700"
                              : item.status === "Berlangsung"
                              ? "bg-sky-100 text-sky-700"
                              : "bg-amber-100 text-amber-700"
                          }`}
                        >
                          {item.status}
                        </span>
                      </td>

                      <td className="p-4">
                        <button
                          onClick={() => setDetail(item)}
                          className="rounded-lg bg-blue-100 px-3 py-2 font-semibold text-blue-700 hover:bg-blue-200"
                        >
                          Lihat Detail
                        </button>
                      </td>
                    </tr>
                  );
                })}

                {hasilFilter.length === 0 && (
                  <tr>
                    <td
                      colSpan={7}
                      className="p-8 text-center text-slate-500"
                    >
                      Data checklist tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* MODAL DETAIL */}
        {detail && (
          <div className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/50 p-4">
            <div className="my-auto w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl">

              <div className="mb-5 flex items-center justify-between">
                <div>
                  <h2 className="text-xl font-bold">
                    Detail Checklist
                  </h2>
                  <p className="mt-1 text-sm text-slate-500">
                    {detail.nama}
                  </p>
                </div>

                <button
                  onClick={() => setDetail(null)}
                  className="text-2xl text-slate-500"
                >
                  ×
                </button>
              </div>

              <div className="mb-5 grid grid-cols-2 gap-3 rounded-xl bg-blue-50 p-4 text-sm">
                <div>
                  <p className="text-slate-500">Tanggal</p>
                  <p className="mt-1 font-semibold">{detail.tanggal}</p>
                </div>
                <div>
                  <p className="text-slate-500">Waktu</p>
                  <p className="mt-1 font-semibold">{detail.jadwal}</p>
                </div>
                <div className="col-span-2">
                  <p className="text-slate-500">Lokasi</p>
                  <p className="mt-1 font-semibold">{detail.lokasi}</p>
                </div>
              </div>

              <h3 className="mb-3 font-bold">
                Checklist Kegiatan
              </h3>

              <div className="space-y-3">
                {detail.kegiatan.map((kegiatan, index) => {
                  const sudah = kegiatan.startsWith("✓ ");

                  return (
                    <label
                      key={index}
                      className="flex cursor-pointer items-center gap-3 rounded-xl border border-slate-200 p-3"
                    >
                      <input
                        type="checkbox"
                        checked={sudah}
                        onChange={() => ubahChecklist(index)}
                        className="h-5 w-5 accent-blue-600"
                      />

                      <span
                        className={
                          sudah
                            ? "text-sm text-emerald-700 line-through"
                            : "text-sm text-slate-700"
                        }
                      >
                        {kegiatan.replace("✓ ", "")}
                      </span>
                    </label>
                  );
                })}
              </div>

              <div className="mt-5">
                <p className="mb-2 text-sm font-semibold">
                  Progress: {hitungPersen(detail.kegiatan)}%
                </p>
                <div className="h-3 overflow-hidden rounded-full bg-slate-200">
                  <div
                    className="h-full rounded-full bg-blue-600"
                    style={{
                      width: `${hitungPersen(detail.kegiatan)}%`,
                    }}
                  />
                </div>
              </div>

              <button
                onClick={() => setDetail(null)}
                className="mt-6 w-full rounded-xl bg-blue-700 py-3 font-semibold text-white hover:bg-blue-800"
              >
                Tutup Detail
              </button>
            </div>
          </div>
        )}
      </div>
    </main>
  );
}

function StatCard({
  judul,
  angka,
  icon,
  warna,
}: {
  judul: string;
  angka: number;
  icon: string;
  warna: string;
}) {
  return (
    <div className="flex items-center gap-4 rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
      <div
        className={`flex h-14 w-14 shrink-0 items-center justify-center rounded-xl text-2xl text-white ${warna}`}
      >
        {icon}
      </div>

      <div>
        <p className="text-sm text-slate-500">{judul}</p>
        <h3 className="text-2xl font-bold">{angka}</h3>
      </div>
    </div>
  );
}
